import Config

# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dapp, Dapp.Repo,
  username: "postgres",
  password: "password1",
  hostname: "localhost",
  database: "dapp_minimal_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 4

# Print warnings and errors running tests
config :logger, level: :warning
