defmodule Dapp.Http.Presenter do
  @moduledoc "Sends use case results as a http json response."
  alias Dapp.Http.Response

  def reply({:error, error}, conn), do: Response.send_json(conn, %{error: error}, 400)

  def reply({:ok, dto}, conn) do
    case conn.method do
      "POST" -> Response.send_json(conn, dto, 201)
      _ -> Response.send_json(conn, dto)
    end
  end
end
