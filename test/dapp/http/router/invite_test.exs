defmodule Dapp.Http.Router.InviteTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Hammox

  # Modules under test
  alias Dapp.Http.Router.Invite, as: InviteRouter

  # Required auth header
  @auth_header Application.compile_env(:dapp, :auth_header)

  # Verifies that all expectations in mock have been called.
  setup :verify_on_exit!

  describe "POST /invites" do
    test "allows admins to create invites" do
      InviteUtil.mock_create_invite()
      admin = UserUtil.mock_http_admin()
      body = %{email: FakeData.generate_email_addresss(), role_id: FakeData.generate_role().id}
      req = conn(:post, "/", body) |> put_req_header(@auth_header, admin.blockchain_address)
      rep = InviteRouter.call(req, [])
      assert rep.status == 201
    end

    test "should fail when no data is passed in the request body" do
      admin = UserUtil.mock_http_admin()
      req = conn(:post, "/") |> put_req_header(@auth_header, admin.blockchain_address)
      rep = InviteRouter.call(req, [])
      assert rep.status == 400
    end
  end

  describe "GET /nonesuch" do
    test "returns a 404" do
      admin = UserUtil.mock_http_admin()
      req = conn(:get, "/nonesuch") |> put_req_header(@auth_header, admin.blockchain_address)
      res = InviteRouter.call(req, [])
      assert res.status == 404
    end
  end
end
