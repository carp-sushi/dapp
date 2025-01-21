defmodule Dapp.UseCase.User.ListUsers do
  @moduledoc """
  List recently created users
  """
  alias Dapp.Dto
  use Dapp.Data.Keeper

  @behaviour Dapp.UseCase
  def execute(_args) do
    users = user_repo().list_recent() |> Enum.map(&Dto.from_schema/1)
    {:ok, %{users: users}}
  end
end
