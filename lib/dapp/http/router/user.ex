defmodule Dapp.Http.Router.User do
  @moduledoc "User routes."
  use Plug.Router

  alias Dapp.Http.{Controller, Response}
  alias Dapp.Rbac.{Access, Auth, Header}
  alias Dapp.UseCase.User.ListUsers

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access)
  plug(:dispatch)

  # Admins can list recently created users.
  get "/recent" do
    Access.admin(conn, fn ->
      Controller.execute(conn, ListUsers)
    end)
  end

  # Catch-all responds with a 404.
  match _ do
    Response.not_found(conn)
  end
end
