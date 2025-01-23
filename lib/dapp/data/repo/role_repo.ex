defmodule Dapp.Data.Repo.RoleRepo do
  @moduledoc """
  Role repository for the dApp.
  """
  @behaviour Dapp.Data.Spec.RoleRepoSpec

  alias Dapp.Data.Schema.Role
  alias Dapp.Repo

  @doc "Get all roles"
  def all, do: Repo.all(Role)
end
