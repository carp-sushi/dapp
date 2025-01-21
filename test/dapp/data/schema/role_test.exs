defmodule Dapp.Data.Schema.RoleTest do
  use ExUnit.Case, async: true

  # Schema being tested
  alias Dapp.Data.Schema.Role

  # Test context
  setup do
    %{
      valid_params: %{name: FakeData.generate_name()},
      empty_name: %{name: ""},
      too_long: %{name: Nanoid.generate(256)}
    }
  end

  # Test role changeset validations
  describe "Role.changeset" do
    test "succeeds on valid params", ctx do
      result = Role.changeset(%Role{}, ctx.valid_params)
      assert result.valid?
    end

    test "fails when name is missing" do
      result = Role.changeset(%Role{}, %{})
      refute result.valid?
      assert result.errors[:name], "expected role name error"
    end

    test "fails when name is empty", ctx do
      result = Role.changeset(%Role{}, ctx.empty_name)
      refute result.valid?
      assert result.errors[:name], "expected role name error"
    end

    test "fails when role name is too long", ctx do
      result = Role.changeset(%Role{}, ctx.too_long)
      refute result.valid?
      assert result.errors[:name], "expected role name error"
    end
  end
end
