defmodule Dapp.UseCase.Invite.CreateInvite do
  @moduledoc """
  Use case for creating a user invites.
  """
  alias Dapp.Dto
  alias Dapp.Util.Validate
  use Dapp.Data.Keeper

  @behaviour Dapp.UseCase
  def execute(args) do
    case Validate.args(args, [:email, :user, :role_id]) do
      :ok -> create_invite(args)
      error -> error
    end
  end

  # Create the new invite using validated args.
  defp create_invite(args) do
    %{email: args.email, user_id: args.user.id, role_id: args.role_id}
    |> invite_repo().create()
    |> case do
      {:ok, invite} -> {:ok, %{invite: Dto.from_schema(invite)}}
      error -> error
    end
  end
end
