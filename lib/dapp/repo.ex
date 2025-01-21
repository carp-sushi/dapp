defmodule Dapp.Repo do
  @moduledoc """
  Postgres database repository.
  """
  use Ecto.Repo,
    otp_app: :dapp,
    adapter: Ecto.Adapters.Postgres
end
