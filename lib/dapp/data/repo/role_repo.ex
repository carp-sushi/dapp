defmodule Dapp.Data.Repo.RoleRepo do
  @moduledoc """
  Role repository for the dApp.
  """
  @behaviour Dapp.Data.Spec.RoleRepoSpec

  alias Dapp.Repo
  alias Dapp.Data.Schema.Role

  @doc "Get all roles"
  def all, do: Repo.all(Role)
end
