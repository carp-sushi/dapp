defmodule Dapp.Http.Router.Protected do
  @moduledoc """
  Maps authorized HTTP requests to use cases.
  """
  use Plug.Router

  alias Dapp.Http.{Controller, Response}
  alias Dapp.Http.Request.InviteRequest
  alias Dapp.Rbac.{Access, Auth, Header}

  alias Dapp.UseCase.Invite.CreateInvite
  alias Dapp.UseCase.Role.ListRoles
  alias Dapp.UseCase.User.{GetProfile, ListUsers}

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Admins can create invites.
  post "/invites" do
    Access.admin(conn, fn ->
      case InviteRequest.validate(conn) do
        {:ok, args} -> Controller.execute(conn, CreateInvite, args)
        {:error, error} -> Response.bad_request(conn, error)
      end
    end)
  end

  # Admins can get available roles.
  get "/roles" do
    Access.admin(conn, fn ->
      Controller.execute(conn, ListRoles)
    end)
  end

  # All authorized users can view their profile.
  get "/profile" do
    Controller.execute(conn, GetProfile)
  end

  # Admins can list recently created users.
  get "/users" do
    Access.admin(conn, fn ->
      Controller.execute(conn, ListUsers)
    end)
  end

  # Catch-all responds with a 404.
  match _ do
    Response.not_found(conn)
  end
end
