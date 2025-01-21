defmodule Dapp.Http.Router.ProtectedTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Hammox

  # Module under test
  alias Dapp.Http.Router.Protected, as: ProtectedRouter

  # Required auth header
  @auth_header Application.compile_env(:dapp, :auth_header)

  # Verifies that all expectations in mock have been called.
  setup :verify_on_exit!

  describe "GET /roles" do
    test "allows admins to list roles" do
      RoleUtil.mock_list_roles(2)
      admin = UserUtil.mock_http_admin()
      req = conn(:get, "/roles") |> put_req_header(@auth_header, admin.blockchain_address)
      rep = ProtectedRouter.call(req, [])
      assert rep.status == 200
    end
  end

  describe "GET /profile" do
    test "returns the profile for an authorized user" do
      user = UserUtil.mock_http_user()
      req = conn(:get, "/profile") |> put_req_header(@auth_header, user.blockchain_address)
      rep = ProtectedRouter.call(req, [])
      assert rep.status == 200
    end
  end

  describe "GET /users" do
    test "allows admins to list recent users" do
      UserUtil.mock_list_users(1)
      admin = UserUtil.mock_http_admin()
      req = conn(:get, "/users") |> put_req_header(@auth_header, admin.blockchain_address)
      rep = ProtectedRouter.call(req, [])
      assert rep.status == 200
    end

    test "blocks non-admins from listing recent users" do
      user = UserUtil.mock_http_user()
      req = conn(:get, "/users") |> put_req_header(@auth_header, user.blockchain_address)
      rep = ProtectedRouter.call(req, [])
      assert rep.status == 401
    end
  end

  describe "POST /invites" do
    test "allows admins to create invites" do
      InviteUtil.mock_create_invite()
      admin = UserUtil.mock_http_admin()
      body = %{email: FakeData.generate_email_addresss(), role_id: FakeData.generate_role().id}
      req = conn(:post, "/invites", body) |> put_req_header(@auth_header, admin.blockchain_address)
      rep = ProtectedRouter.call(req, [])
      # Logger.debug("response body = #{rep.resp_body}")
      assert rep.status == 201
    end

    test "should fail when no data is passed in the request body" do
      admin = UserUtil.mock_http_admin()
      req = conn(:post, "/invites") |> put_req_header(@auth_header, admin.blockchain_address)
      rep = ProtectedRouter.call(req, [])
      assert rep.status == 400
    end
  end

  describe "GET /nonesuch" do
    test "returns a 404" do
      user = UserUtil.mock_http_user()
      req = conn(:get, "/nonesuch") |> put_req_header(@auth_header, user.blockchain_address)
      res = ProtectedRouter.call(req, [])
      assert res.status == 404
    end
  end
end
