defmodule Dapp.Http.Router.Signup do
  @moduledoc """
  Handle signup HTTP requests.
  """
  use Plug.Router

  alias Dapp.Http.Controller
  alias Dapp.Http.Request.SignupRequest
  alias Dapp.Http.Response
  alias Dapp.Rbac.Header
  alias Dapp.UseCase.Invite.Signup

  plug(:match)
  plug(Header)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Allow invited users to signup.
  post "/" do
    case SignupRequest.validate(conn) do
      {:ok, args} -> Controller.execute(conn, Signup, args)
      {:error, error} -> Response.bad_request(conn, error)
    end
  end

  # Catch-all responds with a 404.
  match _ do
    Response.not_found(conn)
  end
end
