defmodule Dapp.Data.Schema.InviteTest do
  use ExUnit.Case, async: true

  # Schema being tested
  alias Dapp.Data.Schema.Invite

  # Test context
  setup do
    %{
      valid_params: %{
        email: FakeData.generate_email_addresss(),
        role_id: :rand.uniform(5),
        user_id: Nanoid.generate()
      },
      missing_email: %{
        role_id: :rand.uniform(5),
        user_id: Nanoid.generate()
      },
      missing_role: %{
        email: FakeData.generate_email_addresss(),
        user_id: Nanoid.generate()
      },
      missing_user: %{
        email: FakeData.generate_email_addresss(),
        role_id: :rand.uniform(5)
      }
    }
  end

  # Test invite changeset validations
  describe "Invite.changeset" do
    test "succeeds on valid params", ctx do
      result = Invite.changeset(%Invite{}, ctx.valid_params)
      assert result.valid?
    end

    test "fails on missing email param", ctx do
      result = Invite.changeset(%Invite{}, ctx.missing_email)
      refute result.valid?
      assert result.errors[:email], "expected email error"
    end

    test "fails on missing role_id param", ctx do
      result = Invite.changeset(%Invite{}, ctx.missing_role)
      refute result.valid?
      assert result.errors[:role_id], "expected role_id error"
    end

    test "fails on missing user_id param", ctx do
      result = Invite.changeset(%Invite{}, ctx.missing_user)
      refute result.valid?
      assert result.errors[:user_id], "expected user_id error"
    end

    test "fails on empty params" do
      result = Invite.changeset(%Invite{}, %{})
      refute result.valid?
    end
  end
end
