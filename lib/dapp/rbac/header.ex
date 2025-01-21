defmodule Dapp.Rbac.Header do
  @moduledoc """
  Extracts blockchain address header.
  """
  import Plug.Conn

  alias Dapp.Http.Response
  alias Dapp.Util.Validate

  # Read header name from config.
  @auth_header Application.compile_env(:dapp, :auth_header)

  @doc false
  def init(opts), do: opts

  @doc "Check for and assign blockchain address from header."
  def call(conn, _opts) do
    case auth_header(conn) do
      nil -> Response.unauthorized(conn)
      blockchain_address -> validate_and_assign_address(conn, blockchain_address)
    end
  end

  @doc "Get blockchain address header."
  def auth_header(conn) do
    case get_req_header(conn, @auth_header) do
      [value] -> value
      _ -> nil
    end
  end

  # Validate header value found in request and assign for upstream use.
  defp validate_and_assign_address(conn, blockchain_address) do
    %{blockchain_address: blockchain_address}
    |> Validate.blockchain_address_params()
    |> case do
      {:ok, data} -> assign(conn, :blockchain_address, data.blockchain_address)
      _ -> Response.unauthorized(conn)
    end
  end
end
