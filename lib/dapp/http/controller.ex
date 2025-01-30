defmodule Dapp.Http.Controller do
  @moduledoc """
  HTTP request handler.
  """
  alias Dapp.Error
  alias Dapp.Http.{Presenter, Response}
  require Logger

  @doc "Execute a use case and send the result as json."
  def execute(conn, use_case, args \\ %{}) do
    args
    |> Map.merge(conn.assigns)
    |> tap(fn args -> Logger.debug("use case args = #{inspect(args)}") end)
    |> use_case.execute()
    |> Presenter.reply(conn)
  rescue
    e ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      {:error, error} = Error.new("internal error: check server logs for details")
      Response.send_json(conn, %{error: error}, 500)
  end
end
