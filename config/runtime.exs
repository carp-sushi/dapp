import Config

# When running in prod, read database URL, connection pool size and schema from environment variables.
if config_env() == :prod do
  db_url = System.get_env("DB_URL") || raise "DB_URL not defined. Example: ecto://USER:PASS@HOST:PORT/DB"
  db_pool_size = System.get_env("DB_POOL_SIZE") || "10"
  db_schema = System.get_env("DB_SCHEMA") || raise "DB_SCHEMA not defined"

  config :dapp, Dapp.Repo,
    url: db_url,
    pool_size: String.to_integer(db_pool_size),
    after_connect: {Postgrex, :query!, ["SET search_path TO #{db_schema}", []]}
end
