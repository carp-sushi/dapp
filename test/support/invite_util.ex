defmodule InviteUtil do
  @moduledoc false
  import Hammox

  alias Dapp.Data.Schema.Invite
  alias Dapp.Data.Schema.User
  alias Dapp.Error
  alias Ecto.Changeset

  @doc """
  Set up a mock for creating validated invites.
  """
  def mock_create_invite do
    expect(MockInviteRepo, :create, fn params ->
      %Invite{id: Nanoid.generate()}
      |> Invite.changeset(params)
      |> evaluate_changeset("invalid invite")
    end)
  end

  @doc """
  Create a fake invite, and define mock repo behaviour for looking up the fake.
  """
  def mock_lookup_invite do
    invite = FakeData.generate_invite()

    expect(MockInviteRepo, :lookup, fn id, email ->
      if id == invite.id && email == invite.email do
        {:ok, invite}
      else
        Error.new("invite not found")
      end
    end)

    invite
  end

  @doc """
  Create a mock for signup (creates a user).
  """
  def mock_signup do
    expect(MockInviteRepo, :signup, fn params, invite ->
      %User{id: Nanoid.generate()}
      |> User.changeset(Map.put(params, :role_id, invite.role_id))
      |> evaluate_changeset("invalid user params")
    end)
  end

  #
  # Evaluate a changeset, returning either a data structure or error.
  #
  defp evaluate_changeset(changeset, message) do
    if changeset.valid? do
      {:ok, Changeset.apply_changes(changeset)}
    else
      Error.new(changeset, message)
    end
  end
end
