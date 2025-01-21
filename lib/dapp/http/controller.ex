defmodule Dapp.Http.Controller do
  @moduledoc """
  HTTP request handler.
  """
  alias Dapp.Http.Response
  require Logger

  @doc "Execute a use case and send the result as json."
  def execute(conn, use_case, args \\ %{}) do
    args
    |> Map.merge(conn.assigns)
    |> tap(&debug_args/1)
    |> use_case.execute()
    |> reply(conn)
  rescue
    e ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      Response.send_json(conn, %{error: %{message: "internal error"}}, 500)
  end

  # Log request args in debug mode.
  defp debug_args(args),
    do: Logger.debug("use case args = #{inspect(args)}")

  # Use case success (204).
  defp reply(:ok, conn),
    do: Response.no_content(conn)

  # Use case success (200, 201).
  defp reply({:ok, dto}, conn) do
    if conn.method == "POST" do
      Response.send_json(conn, dto, 201)
    else
      Response.send_json(conn, dto)
    end
  end

  # Use case failure.
  defp reply({:error, error}, conn) do
    Response.send_json(conn, %{error: error}, 400)
  end
end
