defmodule Dapp.Data.Schema.Invite do
  @moduledoc """
  Schema data mapper for the invites table.
  """
  use Ecto.Schema

  import Ecto.Changeset
  import EctoCommons.EmailValidator

  alias Dapp.Data.Schema.Role
  alias Dapp.Data.Schema.User
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
    |> validate_length(:email, max: 255)
    |> validate_email(:email, checks: [:pow])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:role_id)
    |> unique_constraint(:email)
  end

  # Map an invite schema struct to a data transfer object.
  defimpl Dto do
    def from_schema(struct), do: %{code: struct.id, email: struct.email}
  end
end
