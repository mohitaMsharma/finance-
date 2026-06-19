-- Price-name → business-line mapping for Orb recognized revenue.
-- Re-run to reset seed data; add new rows via INSERT for ongoing maintenance.

CREATE OR REPLACE TABLE `nomadic-bison-363821.finance.dim_price_business_line` (
  price_name STRING NOT NULL,
  business_line STRING NOT NULL,
  revenue_category STRING NOT NULL,
  product_family STRING,
  is_active BOOL NOT NULL,
  effective_from DATE,
  effective_to DATE,
  notes STRING,
  updated_at TIMESTAMP NOT NULL
);

INSERT INTO `nomadic-bison-363821.finance.dim_price_business_line` (
  price_name,
  business_line,
  revenue_category,
  product_family,
  is_active,
  effective_from,
  effective_to,
  notes,
  updated_at
)
SELECT
  price_name,
  business_line,
  revenue_category,
  product_family,
  TRUE AS is_active,
  CAST(NULL AS DATE) AS effective_from,
  CAST(NULL AS DATE) AS effective_to,
  notes,
  CURRENT_TIMESTAMP() AS updated_at
FROM UNNEST([
  -- Serverless
  STRUCT('LLM input tokens (uncached)' AS price_name, 'serverless' AS business_line, 'product' AS revenue_category, 'inference' AS product_family, 'Jarvis serverless allowlist' AS notes),
  STRUCT('LLM input tokens (cached)', 'serverless', 'product', 'inference', 'Jarvis serverless allowlist'),
  STRUCT('LLM output tokens', 'serverless', 'product', 'inference', 'Jarvis serverless allowlist'),
  STRUCT('LLM Input Tokens (uncached) [Enterprise]', 'serverless', 'product', 'inference', 'Jarvis serverless allowlist'),
  STRUCT('LLM Input Tokens (cached) [Enterprise]', 'serverless', 'product', 'inference', 'Jarvis serverless allowlist'),
  STRUCT('LLM Output Tokens [Enterprise]', 'serverless', 'product', 'inference', 'Jarvis serverless allowlist'),
  STRUCT('LLM Input Tokens [Enterprise]', 'serverless', 'product', 'inference', 'Jarvis serverless allowlist'),
  STRUCT('Embedding input tokens', 'serverless', 'product', 'embeddings', 'Jarvis serverless allowlist'),
  STRUCT('Image generation steps', 'serverless', 'product', 'image', 'Jarvis serverless allowlist'),
  STRUCT('flux-1-schnell-fp8 Inference Steps', 'serverless', 'product', 'image', 'Jarvis serverless allowlist'),
  STRUCT('flux-1-dev-fp8 Inference Steps', 'serverless', 'product', 'image', 'Jarvis serverless allowlist'),
  STRUCT('Quora Serverless Image Generations', 'serverless', 'product', 'image', 'Jarvis serverless allowlist'),
  STRUCT('Default Audio Transcription/Translation Input Seconds - 10/12/25', 'serverless', 'product', 'audio', 'Jarvis serverless allowlist'),
  STRUCT('RBI Audio Transcription/Translation Seconds - 10/12/25', 'serverless', 'product', 'audio', 'Jarvis serverless allowlist'),
  STRUCT('Default Audio Transcription – Diarization Surcharge (Seconds) - 10/12/25', 'serverless', 'product', 'audio', 'Jarvis serverless allowlist'),
  STRUCT('Default Streaming Audio Transcriptions Seconds  - 10/12/25', 'serverless', 'product', 'audio', 'Jarvis serverless allowlist'),
  STRUCT('Audio Streaming Transcriptions v2 Seconds', 'serverless', 'product', 'audio', 'Jarvis serverless allowlist'),
  STRUCT('Uber Audio Transcription/Translation Input Seconds - Serverless - 10/12/25', 'serverless', 'product', 'audio', 'Jarvis serverless allowlist'),
  STRUCT('Uber Audio Transcription/Translation Input Seconds - multiple deployments', 'serverless', 'product', 'audio', 'Jarvis serverless allowlist'),
  STRUCT('Radpair Streaming Audio Transcriptions Seconds - 10/12/25', 'serverless', 'product', 'audio', 'Jarvis serverless allowlist'),
  STRUCT('Radpartners Streaming Audio Transcriptions Seconds', 'serverless', 'product', 'audio', 'Jarvis serverless allowlist'),

  -- Fire Pass
  STRUCT('Fireworks AI Coding Pass', 'fire_pass', 'product', 'fire_pass', 'Jarvis fire_pass allowlist'),
  STRUCT('Fire Pass LLM Input Tokens (uncached)', 'fire_pass', 'product', 'fire_pass', 'Jarvis fire_pass allowlist'),
  STRUCT('Fire Pass LLM Input Tokens (cached)', 'fire_pass', 'product', 'fire_pass', 'Jarvis fire_pass allowlist'),
  STRUCT('Fire Pass LLM Output Tokens v2', 'fire_pass', 'product', 'fire_pass', 'Jarvis fire_pass allowlist'),

  -- Deployment
  STRUCT('On-demand deployment GPU-hours', 'deployment', 'product', 'dedicated', 'Jarvis deployment allowlist'),

  -- Fine-tuning / training (current + legacy Orb names)
  STRUCT('Supervised Fine-tuning Tokens', 'fine_tuning', 'product', 'training', 'Jarvis + trainingspend'),
  STRUCT('Managed RFT GPU Hours', 'fine_tuning', 'product', 'training', 'Current default plan'),
  STRUCT('Training API GPU Hours', 'fine_tuning', 'product', 'training', 'Current default plan'),
  STRUCT('Fine-tuning GPU-hours', 'fine_tuning', 'product', 'training', 'Legacy Orb price name'),
  STRUCT('Managed Fine-tuning GPU-hours', 'fine_tuning', 'product', 'training', 'Legacy Orb price name'),
  STRUCT('Reinforcement Fine-tuning GPU-hours', 'fine_tuning', 'product', 'training', 'Legacy Orb price name'),
  STRUCT('Training API GPU-hours', 'fine_tuning', 'product', 'training', 'Legacy Orb price name'),
  STRUCT('RLOR Trainer GPU-hours', 'fine_tuning', 'product', 'training', 'Legacy Orb price name'),

  -- Batched inference
  STRUCT('Batch Inference Output Tokens', 'batched_inference', 'product', 'inference', 'Jarvis batched allowlist'),
  STRUCT('Batch Inference Input Tokens', 'batched_inference', 'product', 'inference', 'Jarvis batched allowlist'),

  -- Contract fixed fees
  STRUCT('Fireworks AI Enterprise Support', 'contract_fixed', 'product', 'contract', 'Enterprise contract plan'),
  STRUCT('Fireworks AI Compute Unit (FCU)', 'contract_fixed', 'product', 'contract', 'Enterprise contract plan'),

  -- Customer-specific meters
  STRUCT('Micro1 Proctor Async Request Count', 'custom_enterprise', 'product', 'custom', 'Micro1 custom plan')
]);
