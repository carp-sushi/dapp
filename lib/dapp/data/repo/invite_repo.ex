defmodule Dapp.Data.Repo.InviteRepo do
  @moduledoc """
  Onboarding repository for the dApp.
  """
  @behaviour Dapp.Data.Spec.InviteRepoSpec

  alias Dapp.{Error, JobQueue, Repo}
  alias Dapp.Data.Schema.{Invite, User}
  alias Dapp.Util.Clock

  alias Ecto.Multi
  import Ecto.Query

  @doc """
  Create an invite.
  """
  def create(params) do
    invite_id = Nanoid.generate()
    job_data = %{"type" => "SendInviteEmail", "data" => Map.put(params, :invite_code, invite_id)}

    Multi.new()
    |> Multi.insert(:invite, Invite.changeset(%Invite{id: invite_id}, params))
    |> JobQueue.enqueue("Invite", job_data)
    |> Repo.transaction()
    |> case do
      {:ok, result} -> {:ok, result.invite}
      {:error, cs} -> Error.new(cs, "failed to create invite")
      {:error, _name, cs, _changes_so_far} -> Error.new(cs, "failed to create invite")
    end
  end

  @doc """
  Look up an invite using id and email address.
  """
  def lookup(id, email) do
    Repo.one(
      from(i in Invite,
        where: i.id == ^id and i.email == ^email and is_nil(i.consumed_at),
        select: i
      )
    )
    |> case do
      nil -> Error.new("invite does not exist or has already been consumed")
      invite -> {:ok, invite}
    end
  end

  @doc """
  Create a user from an invite and mark the invite as consumed.
  """
  def signup(params, invite) do
    user_params = Map.put(params, :role_id, invite.role_id)
    user_changeset = %User{id: Nanoid.generate()} |> User.changeset(user_params)

    invite_changeset = Invite.changeset(invite, %{consumed_at: Clock.now()})

    Multi.new()
    |> Multi.insert(:user, user_changeset)
    |> Multi.update(:invite, invite_changeset)
    |> JobQueue.enqueue("Signup", %{"type" => "SendWelcomeEmail", "data" => user_params})
    |> Repo.transaction()
    |> case do
      {:ok, result} -> {:ok, result.user}
      {:error, cs} -> Error.new(cs, "signup failure")
      {:error, _name, cs, _changes_so_far} -> Error.new(cs, "signup failure")
    end
  end
end
