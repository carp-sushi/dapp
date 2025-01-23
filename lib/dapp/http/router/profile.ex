defmodule Dapp.Http.Router.Profile do
  @moduledoc "User profile router."
  use Plug.Router

  alias Dapp.Http.{Controller, Response}
  alias Dapp.Rbac.{Access, Auth, Header}
  alias Dapp.UseCase.User.GetProfile

  plug(:match)
  plug(Header)
  plug(Auth)
  plug(Access)
  plug(:dispatch)

  # All authorized users can view their profile.
  get "/" do
    Controller.execute(conn, GetProfile)
  end

  # Catch-all responds with a 404.
  match _ do
    Response.not_found(conn)
  end
end
