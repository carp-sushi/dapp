defmodule Dapp.Http.Router.ProfileTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Hammox

  # Modules under test
  alias Dapp.Http.Router.Profile, as: ProfileRouter

  # Required auth header
  @auth_header Application.compile_env(:dapp, :auth_header)

  # Verifies that all expectations in mock have been called.
  setup :verify_on_exit!

  describe "GET /profile" do
    test "returns the profile for an authorized user" do
      user = UserUtil.mock_http_user()
      req = conn(:get, "/") |> put_req_header(@auth_header, user.blockchain_address)
      rep = ProfileRouter.call(req, [])
      assert rep.status == 200
    end
  end

  describe "GET /nonesuch" do
    test "returns a 404" do
      user = UserUtil.mock_http_user()
      req = conn(:get, "/nonesuch") |> put_req_header(@auth_header, user.blockchain_address)
      res = ProfileRouter.call(req, [])
      assert res.status == 404
    end
  end
end
