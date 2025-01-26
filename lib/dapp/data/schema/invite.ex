defmodule Dapp.Data.Schema.Invite do
  @moduledoc """
  Schema data mapper for the invites table.
  """
  import Ecto.Changeset
  use Ecto.Schema

  alias Dapp.Data.Schema.{Role, User}
  alias Dapp.Dto

  # Define type
  @type t() :: %__MODULE__{}

  @primary_key {:id, :string, autogenerate: {Ecto.Nanoid, :autogenerate, []}}
  schema "invites" do
    field(:email, :string)
    field(:consumed_at, :naive_datetime)
    belongs_to(:user, User, type: Ecto.Nanoid)
    belongs_to(:role, Role)
    timestamps()
  end

  @doc "Validate invite changes"
  def changeset(struct, params) do
    struct
    |> cast(params, [:email, :role_id, :user_id, :consumed_at])
    |> validate_required([:email, :role_id, :user_id])
    |> validate_length(:email, min: 3, max: 255)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:role_id)
    |> unique_constraint(:email)
  end

  # Map an invite schema struct to a data transfer object.
  defimpl Dto, for: __MODULE__ do
    def from_schema(struct),
      do: %{code: struct.id, email: struct.email}
  end
end
