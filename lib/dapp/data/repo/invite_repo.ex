defmodule Dapp.Data.Repo.InviteRepo do
  @moduledoc """
  Onboarding repository for the dApp.
  """
  @behaviour Dapp.Data.Spec.InviteRepoSpec

  import Ecto.Query

  alias Dapp.Data.Schema.Invite
  alias Dapp.Data.Schema.User
  alias Dapp.Error
  alias Dapp.Repo
  alias Dapp.Util.Clock
  alias Ecto.Multi

  @doc "Create an invite."
  def create(params) do
    %Invite{}
    |> Invite.changeset(params)
    |> Repo.insert()
    |> case do
      {:error, cs} -> Error.new(cs, "failed to create invite")
      invite -> invite
    end
  end

  @doc "Look up an invite using id and email address."
  def lookup(id, email) do
    case query_invite(id, email) do
      nil -> Error.new("invite does not exist or has already been consumed")
      invite -> {:ok, invite}
    end
  end

  # Get invite helper
  defp query_invite(id, email) do
    Repo.one(
      from(i in Invite,
        where: i.id == ^id and i.email == ^email and is_nil(i.consumed_at),
        select: i
      )
    )
  end

  @doc "Create a user from an invite and mark the invite as consumed."
  def signup(params, invite) do
    user_params = Map.put(params, :role_id, invite.role_id)
    user_changeset = User.changeset(%User{id: Nanoid.generate()}, user_params)
    invite_changeset = Invite.changeset(invite, %{consumed_at: Clock.now()})

    Multi.new()
    |> Multi.insert(:user, user_changeset)
    |> Multi.update(:invite, invite_changeset)
    |> Repo.transaction()
    |> case do
      {:ok, result} -> {:ok, result.user}
      {:error, _name, cs, _changes_so_far} -> Error.new(cs, "signup failure")
    end
  end
end
