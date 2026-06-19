-- Create the finance dataset in nomadic-bison (us-central1).
-- Skip if the dataset already exists.

CREATE SCHEMA IF NOT EXISTS `nomadic-bison-363821.finance`
OPTIONS (
  location = 'us-central1',
  description = 'Finance foundational datasets: recognized revenue, cash, reconciliation'
);
