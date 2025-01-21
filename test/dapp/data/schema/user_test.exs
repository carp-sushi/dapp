defmodule Dapp.Data.Schema.UserTest do
  use ExUnit.Case, async: true

  # Schema being tested
  alias Dapp.Data.Schema.User

  # Test context
  setup do
    %{
      valid_params: %{
        blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskz",
        name: "Jon Doe",
        email: "jon.doe@gmail.com",
        role_id: 1
      },
      bad_prefix: %{blockchain_address: "zz17vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskz", role_id: 1},
      too_short: %{blockchain_address: "tp19vd8fpwxzck93q", role_id: 1},
      too_long: %{
        blockchain_address: "tp16vd8fpwxzck93q1118vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskz8vd8skz",
        role_id: 1
      },
      email_too_short: %{
        email: "a@",
        blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskz",
        role_id: 1
      },
      missing_role_id: %{
        blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskz"
      }
    }
  end

  # Test user changeset validations
  describe "User.changeset" do
    test "succeeds on valid params", ctx do
      result = User.changeset(%User{}, ctx.valid_params)
      assert result.valid?
    end

    test "fails on empty input params" do
      result = User.changeset(%User{}, %{})
      refute result.valid?
    end

    test "fails when blockchain address prefix is invalid", ctx do
      result = User.changeset(%User{}, ctx.bad_prefix)
      refute result.valid?
      assert result.errors[:blockchain_address], "expected blockchain_address error"
    end

    test "fails when blockchain address is too short", ctx do
      result = User.changeset(%User{}, ctx.too_short)
      refute result.valid?
      assert result.errors[:blockchain_address], "expected blockchain_address error"
    end

    test "fails when blockchain address is too long", ctx do
      result = User.changeset(%User{}, ctx.too_long)
      refute result.valid?
      assert result.errors[:blockchain_address], "expected blockchain_address error"
    end

    test "fails when email is too short", ctx do
      result = User.changeset(%User{}, ctx.email_too_short)
      refute result.valid?
      assert result.errors[:email], "expected email error"
    end

    test "fails when role is missing", ctx do
      result = User.changeset(%User{}, ctx.missing_role_id)
      refute result.valid?
      assert result.errors[:role_id], "expected role_id error"
    end
  end
end
