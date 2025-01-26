defmodule Dapp.Data.Repo.UserRepoTest do
  use ExUnit.Case, async: true
  alias Dapp.Repo
  alias Ecto.Adapters.SQL.Sandbox

  # Repo being tested
  alias Dapp.Data.Repo.UserRepo

  # Test context
  setup do
    # When using a sandbox, each test runs in an isolated, independent transaction
    # which is rolled back after test execution.
    :ok = Sandbox.checkout(Dapp.Repo)
    %{address: FakeData.generate_blockchain_address()}
  end

  # Create user helper.
  defp create_user(address) do
    role = Repo.insert!(FakeData.generate_role())
    params = %{blockchain_address: address, email: FakeData.generate_email_addresss(), role_id: role.id}
    UserRepo.create(params)
  end

  # Test user repo
  describe "UserRepo" do
    test "should get a user by blockchain address", ctx do
      assert {:ok, user} = create_user(ctx.address)
      assert UserRepo.get_by_address(ctx.address).id == user.id
    end

    test "should get recent users", ctx do
      assert {:ok, user} = create_user(ctx.address)
      assert [user] == UserRepo.list_recent()
    end

    test "should handle nil blockchain address on get" do
      assert is_nil(UserRepo.get_by_address(nil))
    end
  end
end
