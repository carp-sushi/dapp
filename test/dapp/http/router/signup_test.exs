defmodule Dapp.Http.Router.SignupTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Hammox

  # Module under test
  alias Dapp.Http.Router.Signup, as: SignupRouter

  # Required auth header
  @auth_header Application.compile_env(:dapp, :auth_header)

  # Verifies that all expectations in mock have been called.
  setup :verify_on_exit!

  describe "POST /" do
    test "allows users to sign up" do
      invite = InviteUtil.mock_lookup_invite()
      InviteUtil.mock_signup()
      body = %{invite_code: invite.id, email: invite.email}
      req = conn(:post, "/", body) |> put_req_header(@auth_header, FakeData.generate_blockchain_address())
      rep = SignupRouter.call(req, [])
      assert rep.status == 201
    end

    test "fails when no request body is sent" do
      req = conn(:post, "/") |> put_req_header(@auth_header, FakeData.generate_blockchain_address())
      rep = SignupRouter.call(req, [])
      assert rep.status == 400
    end
  end

  describe "GET /nonesuch" do
    test "returns a 404 for a non-mapped route" do
      req = conn(:get, "/nonesuch") |> put_req_header(@auth_header, FakeData.generate_blockchain_address())
      res = SignupRouter.call(req, [])
      assert res.status == 404
    end
  end
end
