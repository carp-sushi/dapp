defmodule UserUtil do
  @moduledoc false
  import Hammox

  alias Dapp.Data.Schema.Role

  @doc "Setup mock for listing recent users."
  def mock_list_users(size) do
    expect(MockUserRepo, :list_recent, fn -> FakeData.generate_users(size) end)
  end

  @doc "Setup mock for getting a user by blockchain address."
  def mock_http_user, do: mock_user_with_role("User")

  @doc "Setup mock for getting an admin by blockchain address."
  def mock_http_admin, do: mock_user_with_role("Admin")

  # Mock helper for getting a user with a given role name by blockchain address.
  defp mock_user_with_role(name) do
    base = FakeData.generate_user()
    user = %{base | role: %Role{id: base.role_id, name: name}}

    expect(MockUserRepo, :get_by_address, fn blockchain_address ->
      if user.blockchain_address == blockchain_address, do: user
    end)

    user
  end
end
