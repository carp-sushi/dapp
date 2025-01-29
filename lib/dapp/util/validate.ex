defmodule Dapp.Util.Validate do
  @moduledoc """
  Validation helpers.
  """
  alias Dapp.Error
  alias Ecto.Changeset
  import Ecto.Changeset

  @doc "Execute a function with an input map if it contains all required keys."
  def args(map, keys) do
    if is_nil(map) || missing_keys?(map, keys) do
      Error.new("missing required args: #{inspect(keys)}")
    else
      :ok
    end
  end

  # Determine whether any of the required args values are missing.
  defp missing_keys?(map, keys) do
    Enum.any?(keys, fn key ->
      !Map.has_key?(map, key)
    end)
  end

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

    case String.starts_with?(address, network_prefix) do
      true -> changeset
      false -> add_error(changeset, :blockchain_address, "must have prefix: #{network_prefix}")
    end
  end
end
