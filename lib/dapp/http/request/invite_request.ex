defmodule Dapp.Http.Request.InviteRequest do
  @moduledoc """
  Validate requests to create invites.
  """
  alias Dapp.Error

  alias Ecto.Changeset
  import Ecto.Changeset

  @doc "Gather and validate use case args for creating an invite."
  def validate(conn) do
    data = %{}
    types = %{email: :string, role_id: :integer}
    keys = Map.keys(types)

    changeset =
      {data, types}
      |> Changeset.cast(conn.body_params, keys)
      |> validate_required(keys)
      |> validate_length(:email, min: 3, max: 255)
      |> validate_number(:role_id, greater_than: 0)

    case changeset.valid? do
      true -> {:ok, Changeset.apply_changes(changeset)}
      false -> Error.new(changeset, "invalid invite request")
    end
  end
end
