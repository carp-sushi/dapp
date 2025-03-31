defmodule Dapp.UseCase.Role.ListRoles do
  @moduledoc """
  List all available roles.
  """
  use Dapp.UseCase
  use Dapp.Data.Keeper

  alias Dapp.Dto

  @impl true
  def execute(_) do
    roles = Enum.map(role_repo().all(), &Dto.from_schema/1)
    success(%{roles: roles})
  end
end
