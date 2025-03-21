defmodule RoleUtil do
  @moduledoc false
  import Hammox

  @doc "Setup mock for listing all roles"
  def mock_list_roles(size) do
    expect(MockRoleRepo, :all, fn -> FakeData.generate_roles(size) end)
  end
end
