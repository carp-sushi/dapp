defmodule Dapp.Http.Router.Role do
  @moduledoc """
  Handle role HTTP requests.
  """
  use Plug.Router

  alias Dapp.Http.{Controller, Response}
  alias Dapp.Rbac.{Access, Auth, Header}
  alias Dapp.UseCase.Role.ListRoles

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access, roles: ["Admin"])
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Admins can get available roles.
  get "/" do
    Controller.execute(conn, ListRoles)
  end

  # Catch-all responds with a 404.
  match _ do
    Response.not_found(conn)
  end
end
