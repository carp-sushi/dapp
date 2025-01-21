defmodule Dapp.Http.Request.SignupRequest do
  @moduledoc """
  Validate signup requests.
  """
  alias Dapp.Error

  alias Ecto.Changeset
  import Ecto.Changeset

  @doc "Gather and validate use case args for user signup."
  def validate(conn) do
    args = %{blockchain_address: conn.assigns.blockchain_address}
    types = %{invite_code: :string, name: :string, email: :string}
    keys = Map.keys(types)

    changeset =
      {args, types}
      |> Changeset.cast(conn.body_params, keys)
      |> validate_required([:invite_code, :email])
      |> validate_length(:invite_code, max: 21)
      |> validate_length(:name, max: 255)
      |> validate_length(:email, min: 3, max: 255)

    case changeset.valid? do
      true -> {:ok, Changeset.apply_changes(changeset)}
      false -> Error.new(changeset, "invalid signup request")
    end
  end
end
