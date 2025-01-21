defmodule InviteUtil do
  @moduledoc false
  alias Dapp.Data.Schema.{Invite, User}
  alias Dapp.Error
  alias Ecto.Changeset
  import Hammox

  @doc """
  Set up a mock for creating validated invites.
  """
  def mock_create_invite do
    MockInviteRepo
    |> expect(:create, fn params ->
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

    MockInviteRepo
    |> expect(:lookup, fn id, email ->
      case id == invite.id && email == invite.email do
        true -> {:ok, invite}
        false -> Error.new("invite not found")
      end
    end)

    invite
  end

  @doc """
  Create a mock for signup (creates a user).
  """
  def mock_signup do
    MockInviteRepo
    |> expect(:signup, fn params, invite ->
      %User{id: Nanoid.generate()}
      |> User.changeset(Map.put(params, :role_id, invite.role_id))
      |> evaluate_changeset("invalid user params")
    end)
  end

  #
  # Evaluate a changeset, returning either a data structure or error.
  #
  defp evaluate_changeset(changeset, message) do
    case changeset.valid? do
      true -> {:ok, Changeset.apply_changes(changeset)}
      false -> Error.new(changeset, message)
    end
  end
end
