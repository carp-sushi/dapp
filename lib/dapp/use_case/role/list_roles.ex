defmodule Dapp.UseCase.Role.ListRoles do
  @moduledoc """
  List all available roles.
  """
  @behaviour Dapp.UseCase

  use Dapp.Data.Keeper

  alias Dapp.Dto

  def execute(_args) do
    roles = Enum.map(role_repo().all(), &Dto.from_schema/1)
    {:ok, %{roles: roles}}
  end
end
