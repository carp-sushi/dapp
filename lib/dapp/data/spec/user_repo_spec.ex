defmodule Dapp.Data.Spec.UserRepoSpec do
  @moduledoc """
  Data layer specification for managing users.
  """
  alias Dapp.Data.Schema.User

  @callback create(map) :: {:ok, User.t()} | {:error, any}
  @callback get_by_address(String.t()) :: User.t() | nil
  @callback list_recent :: list(User.t())
end
