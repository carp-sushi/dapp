defmodule Dapp.UseCase.User.GetProfile do
  @moduledoc """
  Show the authorized user's profile.
  """
  use Dapp.UseCase

  alias Dapp.Dto
  alias Dapp.Error

  @impl true
  def execute(args) do
    case Map.get(args, :user) do
      nil -> fail("missing required arg: user")
      user -> success(%{profile: Dto.from_schema(user)})
    end
  end
end
