defmodule Dapp.Util.Validate do
  @moduledoc """
  Validation helpers.
  """
  import Ecto.Changeset

  alias Dapp.Error
  alias Ecto.Changeset

  @doc "Validate a blockhain address in a parameter map."
  def blockchain_address_params(params) do
    data = %{}
    types = %{blockchain_address: :string}
    keys = Map.keys(types)

    changeset =
      {data, types}
      |> Changeset.cast(params, keys)
      |> blockchain_address_changeset()

    if changeset.valid? do
      {:ok, Changeset.apply_changes(changeset)}
    else
      Error.new(changeset, "invalid blockchain address")
    end
  end

  @doc "Validate a blockhain address"
  def blockchain_address_changeset(changeset) do
    changeset
    |> validate_required([:blockchain_address])
    |> validate_length(:blockchain_address, min: 41, max: 61)
    |> validate_address_prefix()
  end

  # "Validate blockchain address prefix."
  defp validate_address_prefix(changeset) do
    case get_field(changeset, :blockchain_address) do
      nil -> changeset
      address -> validate_address_prefix(changeset, address)
    end
  end

  # Validate blockchain address prefix.
  defp validate_address_prefix(changeset, address) do
    network_prefix = System.get_env("NETWORK_PREFIX", "pb")

    if String.starts_with?(address, network_prefix) do
      changeset
    else
      add_error(changeset, :blockchain_address, "must have prefix: #{network_prefix}")
    end
  end
end
