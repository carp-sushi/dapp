defmodule Dapp.Http.Router.UserTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Hammox

  # Modules under test
  alias Dapp.Http.Router.User, as: UserRouter

  # Required auth header
  @auth_header Application.compile_env(:dapp, :auth_header)

  # Verifies that all expectations in mock have been called.
  setup :verify_on_exit!

  describe "GET /users/recent" do
    test "allows admins to list recent users" do
      UserUtil.mock_list_users(1)
      admin = UserUtil.mock_http_admin()
      req = conn(:get, "/recent") |> put_req_header(@auth_header, admin.blockchain_address)
      rep = UserRouter.call(req, [])
      assert rep.status == 200
    end

    test "prevents non-admins from listing recent users" do
      user = UserUtil.mock_http_user()
      req = conn(:get, "/recent") |> put_req_header(@auth_header, user.blockchain_address)
      rep = UserRouter.call(req, [])
      assert rep.status == 401
    end
  end

  describe "GET /users/profile" do
    test "returns the profile for an authorized user" do
      user = UserUtil.mock_http_user()
      req = conn(:get, "/profile") |> put_req_header(@auth_header, user.blockchain_address)
      rep = UserRouter.call(req, [])
      assert rep.status == 200
    end
  end

  describe "GET /nonesuch" do
    test "returns a 404" do
      user = UserUtil.mock_http_user()
      req = conn(:get, "/nonesuch") |> put_req_header(@auth_header, user.blockchain_address)
      res = UserRouter.call(req, [])
      assert res.status == 404
    end
  end
end
