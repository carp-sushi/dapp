defmodule Dapp.Http.Router.Invite do
  @moduledoc """
  Handle invite HTTP requests.
  """
  use Plug.Router

  alias Dapp.Http.{Controller, Request.InviteRequest, Response}
  alias Dapp.Rbac.{Access, Auth, Header}
  alias Dapp.UseCase.Invite.CreateInvite

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access, roles: ["Admin"])
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Admins can create invites.
  post "/" do
    case InviteRequest.validate(conn) do
      {:ok, args} -> Controller.execute(conn, CreateInvite, args)
      {:error, error} -> Response.bad_request(conn, error)
    end
  end

  # Catch-all responds with a 404.
  match _ do
    Response.not_found(conn)
  end
end
