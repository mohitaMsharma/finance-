-- Initial load: Orb revenue at event grain with business-line classification.
-- Location: us-central1

CREATE OR REPLACE TABLE `nomadic-bison-363821.finance.fct_orb_revenue_events`
PARTITION BY revenue_day
CLUSTER BY account_id, business_line
AS
WITH source AS (
  SELECT
    e.created_at,
    e.account_id,
    e.customer_id,
    e.price_id,
    e.price_name,
    e.total,
    e.sub_line_items,
    COALESCE(e.is_enterprise, FALSE) AS is_enterprise,
    e.account_type
  FROM `nomadic-bison-363821.reporting.orb_daily_revenue_events_labeled` AS e
  WHERE e.account_id IS NOT NULL
    AND LOWER(e.account_id) NOT IN ('fireworks', 'pyroworks')
),
classified AS (
  SELECT
    s.*,
    COALESCE(
      m.business_line,
      CASE
        WHEN s.price_id IS NULL THEN 'credits_and_adjustments'
        WHEN LOWER(s.price_name) LIKE '%serverless training%' THEN 'fine_tuning'
        WHEN s.price_name LIKE '%Proctor%' THEN 'custom_enterprise'
        ELSE 'unmapped'
      END
    ) AS business_line,
    COALESCE(
      m.revenue_category,
      IF(s.price_id IS NULL, 'credits_and_adjustments', 'product')
    ) AS revenue_category
  FROM source AS s
  LEFT JOIN `nomadic-bison-363821.finance.dim_price_business_line` AS m
    ON s.price_name = m.price_name
   AND m.is_active
   AND (m.effective_from IS NULL OR DATE(s.created_at) >= m.effective_from)
   AND (m.effective_to IS NULL OR DATE(s.created_at) <= m.effective_to)
)
SELECT
  TO_HEX(MD5(CONCAT(
    COALESCE(CAST(created_at AS STRING), ''),
    '|',
    COALESCE(account_id, ''),
    '|',
    COALESCE(customer_id, ''),
    '|',
    COALESCE(price_id, ''),
    '|',
    COALESCE(price_name, ''),
    '|',
    COALESCE(CAST(total AS STRING), '')
  ))) AS event_id,

  DATE(created_at) AS revenue_day,
  created_at AS revenue_ts,

  account_id,
  customer_id,
  price_id,
  price_name,

  business_line,
  revenue_category,

  CASE
    WHEN price_id IS NULL AND total > 0 THEN 'grant'
    WHEN price_id IS NULL AND total < 0 THEN 'consumption'
    WHEN price_id IS NULL THEN 'neutral'
  END AS credit_direction,

  is_enterprise,
  account_type,

  CAST(total AS NUMERIC) AS amount_usd,
  total = 0 AS is_zero_amount,

  sub_line_items,

  'orb' AS source_system,
  'recognized' AS revenue_type,

  CURRENT_TIMESTAMP() AS loaded_at
FROM classified;
