defmodule Dapp.Rbac.Auth do
  @moduledoc """
  Authorizes requests with a blockchain address header.
  """
  use Dapp.Data.Keeper

  import Plug.Conn

  alias Dapp.Http.Response

  @doc false
  def init(opts), do: opts

  @doc "Authorize requests that have a verified blockchain address."
  def call(conn, _opts) do
    conn.assigns
    |> Map.get(:blockchain_address)
    |> user_repo().get_by_address()
    |> case do
      nil -> Response.unauthorized(conn)
      user -> assign(conn, :user, user)
    end
  end
end
