import Config

# Print warnings and errors in production
config :logger, level: :warning

# Increase max data-set size in prod
config :dapp,
  max_records: 1000
