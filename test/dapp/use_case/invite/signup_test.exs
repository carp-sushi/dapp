defmodule Dapp.UseCase.Invite.SignupTest do
  use ExUnit.Case, async: true
  import Hammox

  # Use case under test
  alias Dapp.UseCase.Invite.Signup

  # Verifies that all expectations in mock have been called.
  setup_all :verify_on_exit!

  # Setup invite mocks and args in a test context.
  setup do
    invite = InviteUtil.mock_lookup_invite()
    InviteUtil.mock_signup()
    blockchain_address = FakeData.generate_blockchain_address()
    args = %{invite_code: invite.id, email: invite.email, blockchain_address: blockchain_address}
    %{args: args, expect: %{email: invite.email}}
  end

  # Signup use case tests
  describe "Signup" do
    test "should create a new user given valid args", ctx do
      assert {:ok, %{profile: user}} = Signup.execute(ctx.args)
      assert user.email == ctx.expect.email
    end

    test "should fail to create a new user when the invite is not found", ctx do
      args = Map.merge(ctx.args, %{invite_code: Nanoid.generate()})
      assert {:error, %{message: "invite not found"}} = Signup.execute(args)
    end

    test "should fail to create a new user with invalid params", ctx do
      args = %{invite_code: ctx.args.invite_code, email: ctx.args.email}
      assert {:error, %{message: "invalid user params"}} = Signup.execute(args)
    end
  end
end
