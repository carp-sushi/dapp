defmodule Dapp.Plug do
  @moduledoc """
  Top-level plug: handles health requests or forwards to internal api routers.
  """
  use Plug.Router
  alias Dapp.Http.{Response, Router}

  if Mix.env() == :dev do
    use Plug.Debugger, otp_app: :dapp
  end

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  # Read URI from config
  @uri_base Application.compile_env(:dapp, :uri_base)

  # Top-level routing
  forward("#{@uri_base}/invites", to: Router.Invite)
  forward("#{@uri_base}/roles", to: Router.Role)
  forward("#{@uri_base}/signup", to: Router.Signup)
  forward("#{@uri_base}/users", to: Router.User)

  # Health checks.
  get "/health/*glob" do
    Response.send_json(conn, %{status: "up"})
  end

  # Respond with 404.
  match _ do
    Response.not_found(conn)
  end
end
