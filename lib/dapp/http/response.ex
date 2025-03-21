defmodule Dapp.Http.Response do
  @moduledoc """
  HTTP response helper module.
  """
  import Plug.Conn

  if Mix.env() == :dev do
    @pretty true
  else
    @pretty false
  end

  @doc "Send a bad request response."
  def bad_request(conn, error), do: send_json(conn, %{error: error}, 400)

  @doc "Not found error helper."
  def not_found(conn) do
    conn
    |> send_json(%{error: %{message: "route not found"}}, 404)
    |> halt()
  end

  @doc "Unauthorized request error helper."
  def unauthorized(conn) do
    conn
    |> send_json(%{error: %{message: "unauthorized"}}, 401)
    |> halt()
  end

  @doc "Encode data to JSON and send as a HTTP response."
  def send_json(conn, data, status \\ 200) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(data, pretty: @pretty))
  end
end
