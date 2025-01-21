defmodule Dapp.Data.Repo.RoleRepoTest do
  use ExUnit.Case, async: true
  alias Ecto.Adapters.SQL.Sandbox

  # Repo being tested
  alias Dapp.Data.Repo.RoleRepo

  # Set up SQL sandbox.
  setup do
    :ok = Sandbox.checkout(Dapp.Repo)
  end

  # Test that repo can query roles from the db.
  describe "RoleRepo" do
    test "should return all stored roles" do
      size = :rand.uniform(5)
      FakeData.generate_roles(size) |> Enum.each(&Dapp.Repo.insert!/1)
      roles = RoleRepo.all()
      assert length(roles) == size
    end
  end
end
