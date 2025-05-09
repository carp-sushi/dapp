defmodule Dapp.Plug do
  @moduledoc """
  Top-level plug: handles health requests or forwards to internal api routers.
  """
  use Plug.Router

  alias Dapp.Http.Response
  alias Dapp.Http.Router.InviteRouter
  alias Dapp.Http.Router.RoleRouter
  alias Dapp.Http.Router.SignupRouter
  alias Dapp.Http.Router.UserRouter

  if Mix.env() == :dev do
    use Plug.Debugger, otp_app: :dapp
  end

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  # Read URI from config
  @uri_base Application.compile_env(:dapp, :uri_base)

  # Top-level routing
  forward("#{@uri_base}/invites", to: InviteRouter)
  forward("#{@uri_base}/roles", to: RoleRouter)
  forward("#{@uri_base}/signup", to: SignupRouter)
  forward("#{@uri_base}/users", to: UserRouter)

  # Health checks.
  get "/health/*glob" do
    Response.send_json(conn, %{status: "up"})
  end

  # Respond with 404.
  match _ do
    Response.not_found(conn)
  end
end
