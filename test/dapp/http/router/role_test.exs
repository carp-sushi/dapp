defmodule Dapp.Http.Router.RoleTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Hammox

  # Modules under test
  alias Dapp.Http.Router.Role, as: RoleRouter

  # Required auth header
  @auth_header Application.compile_env(:dapp, :auth_header)

  # Verifies that all expectations in mock have been called.
  setup :verify_on_exit!

  describe "GET /roles" do
    test "allows admins to list roles" do
      RoleUtil.mock_list_roles(2)
      admin = UserUtil.mock_http_admin()
      req = conn(:get, "/") |> put_req_header(@auth_header, admin.blockchain_address)
      rep = RoleRouter.call(req, [])
      assert rep.status == 200
    end
  end

  describe "GET /nonesuch" do
    test "returns a 404 for a non-mapped route" do
      admin = UserUtil.mock_http_admin()
      req = conn(:get, "/nonesuch") |> put_req_header(@auth_header, admin.blockchain_address)
      res = RoleRouter.call(req, [])
      assert res.status == 404
    end
  end
end
