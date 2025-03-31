defmodule Dapp.UseCase.User.ListUsers do
  @moduledoc """
  List recently created users.
  """
  use Dapp.UseCase
  use Dapp.Data.Keeper

  alias Dapp.Dto

  @impl true
  def execute(_) do
    users = Enum.map(user_repo().list_recent(), &Dto.from_schema/1)
    success(%{users: users})
  end
end
