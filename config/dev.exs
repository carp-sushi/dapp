import Config

config :dapp, Dapp.Repo,
  database: "dapp_minimal_dev",
  username: "postgres",
  password: "password1",
  hostname: "localhost",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 4
