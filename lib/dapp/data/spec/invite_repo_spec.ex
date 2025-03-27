defmodule Dapp.Data.Spec.InviteRepoSpec do
  @moduledoc """
  Data layer specification for managing inivtes.
  """
  alias Dapp.Data.Schema.Invite
  alias Dapp.Data.Schema.User

  @callback create(map) :: {:ok, Invite.t()} | {:error, any}
  @callback lookup(String.t(), String.t()) :: {:ok, Invite.t()} | {:error, any}
  @callback signup(map, Invite.t()) :: {:ok, User.t()} | {:error, any}
end
