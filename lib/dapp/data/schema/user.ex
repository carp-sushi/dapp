defmodule Dapp.Data.Schema.User do
  @moduledoc """
  Schema data mapper for the users table.
  """
  use Ecto.Schema

  import Ecto.Changeset
  import EctoCommons.EmailValidator

  alias Dapp.Data.Schema.Role
  alias Dapp.Dto
  alias Dapp.Util.Validate

  # Define type
  @type t() :: %__MODULE__{}

  @primary_key {:id, :string, autogenerate: {Ecto.Nanoid, :autogenerate, []}}
  schema "users" do
    field(:blockchain_address, :string)
    field(:email, :string)
    field(:name, :string)
    belongs_to(:role, Role)
    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:blockchain_address, :email, :name, :role_id])
    |> validate_required([:blockchain_address, :email, :role_id])
    |> validate_length(:name, max: 255)
    |> validate_length(:email, max: 255)
    |> validate_email(:email, checks: [:pow])
    |> unique_constraint(:blockchain_address)
    |> unique_constraint(:email)
    |> foreign_key_constraint(:role_id)
    |> Validate.blockchain_address_changeset()
  end

  # Map a user schema struct to a data transfer object.
  defimpl Dto do
    def from_schema(struct),
      do: %{id: struct.id, blockchain_address: struct.blockchain_address, name: struct.name, email: struct.email}
  end
end
