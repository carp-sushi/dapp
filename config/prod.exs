import Config

# Increase max data-set size in prod
config :dapp,
  max_records: 100

# Print warnings and errors in production
config :logger, level: :warning
