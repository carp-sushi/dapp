defmodule Dapp.Data.Repo.InviteRepoTest do
  use ExUnit.Case, async: true
  alias Dapp.Data.Repo.UserRepo
  alias Dapp.Repo
  alias Ecto.Adapters.SQL.Sandbox

  # Repo being tested
  alias Dapp.Data.Repo.InviteRepo

  # Setup test context
  setup do
    :ok = Sandbox.checkout(Dapp.Repo)
    {:ok, admin, role} = create_user()

    %{
      admin: admin,
      role: role,
      params: %{
        email: FakeData.generate_email_addresss(),
        user_id: admin.id,
        role_id: role.id
      }
    }
  end

  # Create user helper.
  defp create_user do
    role = Repo.insert!(FakeData.generate_role())
    address = FakeData.generate_blockchain_address()
    email = FakeData.generate_email_addresss()
    {:ok, user} = UserRepo.create(%{blockchain_address: address, email: email, role_id: role.id})
    {:ok, user, role}
  end

  # Test signup repo
  describe "InviteRepo" do
    test "should enable user signups via invite given valid params", ctx do
      # Test invite creation by admin step
      assert {:ok, created} = InviteRepo.create(ctx.params)
      assert created.user_id == ctx.admin.id
      assert created.role_id == ctx.role.id

      # Test lookup step
      assert {:ok, invite} = InviteRepo.lookup(created.id, ctx.params.email)
      assert invite.email == created.email

      # Test user signup step
      blockchain_address = FakeData.generate_blockchain_address()
      user_params = %{blockchain_address: blockchain_address, email: ctx.params.email}
      assert {:ok, user} = InviteRepo.signup(user_params, invite)
      assert user.role_id == invite.role_id

      # Ensure invite has been consumed
      assert {:error, error} = InviteRepo.lookup(created.id, ctx.params.email)
      assert error.message == "invite does not exist or has already been consumed"
    end

    test "should fail to create an invite given empty params" do
      assert {:error, error} = InviteRepo.create(%{})
      assert error.message == "failed to create invite"
    end

    test "should fail looking up an invite that does not exist" do
      assert {:error, error} = InviteRepo.lookup(Nanoid.generate(), FakeData.generate_email_addresss())
      assert error.message == "invite does not exist or has already been consumed"
    end
  end
end
