defmodule Dapp.UseCase.User.ListUsers do
  @moduledoc """
  List recently created users
  """
  @behaviour Dapp.UseCase

  use Dapp.Data.Keeper

  alias Dapp.Dto

  def execute(_args) do
    users = Enum.map(user_repo().list_recent(), &Dto.from_schema/1)
    {:ok, %{users: users}}
  end
end
