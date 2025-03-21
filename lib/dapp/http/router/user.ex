defmodule Dapp.Http.Router.User do
  @moduledoc """
  Handle user HTTP requests.
  """
  use Plug.Router

  alias Dapp.Http.Controller
  alias Dapp.Http.Response
  alias Dapp.Rbac.Access
  alias Dapp.Rbac.Auth
  alias Dapp.Rbac.Header
  alias Dapp.UseCase.User.GetProfile
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

  # All authorized users can view their profile.
  get "/profile" do
    Controller.execute(conn, GetProfile)
  end

  # Catch-all responds with a 404.
  match _ do
    Response.not_found(conn)
  end
end
