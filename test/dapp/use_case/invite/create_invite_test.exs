defmodule Dapp.UseCase.Invite.CreateInviteTest do
  use ExUnit.Case, async: true

  import Hammox

  # Use case under test
  alias Dapp.UseCase.Invite.CreateInvite

  # Verifies that all expectations in mock have been called.
  setup_all :verify_on_exit!

  # Setup a mock invite and args in a test context.
  setup do
    InviteUtil.mock_create_invite()
    role = FakeData.generate_role()
    email = FakeData.generate_email_addresss()
    args = %{user: FakeData.generate_user(role.id), email: email, role_id: role.id}
    %{args: args, expect: %{email: email}}
  end

  # CreateInvite use case tests
  describe "CreateInvite" do
    test "should create a new invite given valid args", ctx do
      assert {:ok, %{invite: invite}} = CreateInvite.execute(ctx.args)
      assert invite.email == ctx.expect.email
    end

    test "should fail to create a new invite given empty args" do
      assert {:error, error} = CreateInvite.execute(%{})
      assert error.message == "missing required args: [:email, :user, :role_id]"
    end

    test "should fail to create a new invite given invalid args", ctx do
      args = Map.put(ctx.args, :email, "a@")
      assert {:error, %{message: "invalid invite"}} = CreateInvite.execute(args)
    end
  end
end
