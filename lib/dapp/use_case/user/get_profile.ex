defmodule Dapp.UseCase.User.GetProfile do
  @moduledoc """
  Show the authorized user's profile.
  """
  alias Dapp.{Dto, Error}

  @behaviour Dapp.UseCase
  def execute(args) do
    case Map.get(args, :user) do
      nil -> Error.new("missing required arg: user")
      user -> {:ok, %{profile: Dto.from_schema(user)}}
    end
  end
end
