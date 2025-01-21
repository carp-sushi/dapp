defmodule Dapp.UseCase.User.ListUsersTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case being tested
  alias Dapp.UseCase.User.ListUsers

  # Verify mocks on exit
  setup_all :verify_on_exit!

  # Set up mock repo for test
  setup do
    size = :rand.uniform(5)
    UserUtil.mock_list_users(size)
    %{args: %{}, expect: %{size: size}}
  end

  # ListUsers use case test
  describe "ListUsers" do
    test "should return recent users", ctx do
      assert {:ok, %{users: users}} = ListUsers.execute(ctx.args)
      assert length(users) == ctx.expect.size
    end
  end
end
