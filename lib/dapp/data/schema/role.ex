defmodule Dapp.Data.Schema.Role do
  @moduledoc """
  Schema data mapper for the roles table.
  """
  import Ecto.Changeset
  use Ecto.Schema

  alias Dapp.Dto

  # Define type
  @type t() :: %__MODULE__{}

  schema "roles" do
    field(:name, :string)
  end

  @doc "Validate role changes"
  def changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 255)
    |> unique_constraint(:name)
  end

  # Map a role schema struct to a data transfer object.
  defimpl Dto, for: __MODULE__ do
    def from_schema(struct),
      do: %{id: struct.id, name: struct.name}
  end
end
