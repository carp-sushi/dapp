defmodule Dapp.Error do
  @moduledoc """
  Project level errors.
  """

  @doc "Create a new error with simple message."
  def new(message) do
    {:error, %{message: message}}
  end

  @doc "Create a new error from a changeset."
  def new(changeset, message) do
    {:error, %{message: message, details: error_details(changeset)}}
  end

  # Get ecto changeset error detail. This was taken directly from Phoenix.
  defp error_details(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
