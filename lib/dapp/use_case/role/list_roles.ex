defmodule Dapp.UseCase.Role.ListRoles do
  @moduledoc """
  List all available roles.
  """
  alias Dapp.Dto
  use Dapp.Data.Keeper

  @behaviour Dapp.UseCase
  def execute(_args) do
    roles = role_repo().all() |> Enum.map(&Dto.from_schema/1)
    {:ok, %{roles: roles}}
  end
end
