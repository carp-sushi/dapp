defmodule Dapp.Data.Repo.UserRepo do
  @moduledoc """
  User repository for the dApp.
  """
  @behaviour Dapp.Data.Spec.UserRepoSpec

  import Ecto.Query

  alias Dapp.Data.Schema.User
  alias Dapp.Error
  alias Dapp.Repo

  # Sets a maximum on query result size.
  @max_records Application.compile_env(:dapp, :max_records)

  @doc "Create a user."
  def create(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
    |> case do
      {:error, cs} -> Error.new(cs, "failed to create user")
      success -> success
    end
  end

  @doc "Query for the user with the given blockchain address."
  def get_by_address(blockchain_address) do
    if !is_nil(blockchain_address) do
      User
      |> Repo.get_by(blockchain_address: blockchain_address)
      |> Repo.preload(:role)
    end
  end

  @doc "Get recently created users"
  def list_recent do
    Repo.all(
      from(u in User,
        order_by: [desc: u.inserted_at],
        limit: @max_records,
        select: u
      )
    )
  end
end
