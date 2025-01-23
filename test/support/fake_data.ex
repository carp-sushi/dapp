defmodule FakeData do
  @moduledoc """
  Test helper functions for generating fake data.
  """
  alias Dapp.Data.Schema.{Invite, Role, User}

  @doc "Generate a fake blockchain address."
  def generate_blockchain_address,
    do: "tp#{Nanoid.generate(39)}" |> String.downcase()

  @doc "Generate a fake email address"
  def generate_email_addresss,
    do: "email#{Nanoid.generate(5)}@fakedomain.com"

  @doc "Generate a fake name"
  def generate_name,
    do: "name#{Nanoid.generate(5)}"

  @doc "Generate a fake role"
  def generate_role,
    do: %Role{
      id: :rand.uniform(100),
      name: generate_name()
    }

  @doc "Generate a sequence of fake roles"
  def generate_roles(size),
    do: Stream.repeatedly(&generate_role/0) |> Enum.take(size)

  @doc "Generate a fake user"
  def generate_user(role_id \\ nil),
    do: %User{
      id: Nanoid.generate(),
      blockchain_address: generate_blockchain_address(),
      name: generate_name(),
      email: generate_email_addresss(),
      role_id: role_id || generate_role().id
    }

  @doc "Generate a sequence of fake users"
  def generate_users(size),
    do: Stream.repeatedly(&generate_user/0) |> Enum.take(size)

  @doc "Generate a fake invite"
  def generate_invite(user_id \\ nil),
    do: %Invite{
      id: Nanoid.generate(),
      email: generate_email_addresss(),
      role_id: generate_role().id,
      user_id: user_id || Nanoid.generate()
    }
end
