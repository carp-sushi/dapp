defmodule Dapp.UseCase.Role.ListRolesTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case being tested
  alias Dapp.UseCase.Role.ListRoles

  # Verify mocks on exit
  setup_all :verify_on_exit!

  # Set up mock repo for test
  setup do
    size = :rand.uniform(5)
    RoleUtil.mock_list_roles(size)
    %{args: %{}, expect: %{size: size}}
  end

  # ListRoles use case test
  describe "ListRoles" do
    test "should return all roles", ctx do
      assert {:ok, %{roles: roles}} = ListRoles.execute(ctx.args)
      assert length(roles) == ctx.expect.size
    end
  end
end
