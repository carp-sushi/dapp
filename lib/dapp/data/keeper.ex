defmodule Dapp.Data.Keeper do
  @moduledoc """
  Macro for loading repos (allows injecting mocks for testing).
  """
  defmacro __using__(_opts) do
    quote do
      alias Dapp.Data.Repo.{InviteRepo, RoleRepo, UserRepo}
      alias Dapp.Data.Spec.{InviteRepoSpec, RoleRepoSpec, UserRepoSpec}

      @spec invite_repo :: InviteRepoSpec
      defp invite_repo, do: Application.get_env(:dapp, :invite_repo, InviteRepo)

      @spec role_repo :: RoleRepoSpec
      defp role_repo, do: Application.get_env(:dapp, :role_repo, RoleRepo)

      @spec user_repo :: UserRepoSpec
      defp user_repo, do: Application.get_env(:dapp, :user_repo, UserRepo)
    end
  end
end
