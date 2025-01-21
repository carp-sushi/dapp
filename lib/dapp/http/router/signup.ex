defmodule Dapp.Http.Router.Signup do
  @moduledoc """
  Signup specific router. Only requires account address header.
  """
  use Plug.Router

  alias Dapp.Http.{Controller, Request.SignupRequest, Response}
  alias Dapp.Rbac.Header
  alias Dapp.UseCase.Invite.Signup

  plug(:match)
  plug(Header)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Allow invited users to signup with the dApp.
  post "/" do
    case SignupRequest.validate(conn) do
      {:ok, args} -> Controller.execute(conn, Signup, args)
      {:error, error} -> Response.bad_request(conn, error)
    end
  end
end
