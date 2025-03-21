defmodule Dapp.UseCase.User.GetProfile do
  @moduledoc """
  Show the authorized user's profile.
  """
  @behaviour Dapp.UseCase

  alias Dapp.Dto
  alias Dapp.Error

  def execute(args) do
    case Map.get(args, :user) do
      nil -> Error.new("missing required arg: user")
      user -> {:ok, %{profile: Dto.from_schema(user)}}
    end
  end
end
