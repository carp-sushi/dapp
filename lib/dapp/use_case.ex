defmodule Dapp.UseCase do
  @moduledoc """
  Defines use case behaviour.
  """
  @callback execute(args :: map) :: {:ok, dto :: map} | {:error, error :: map}

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour Dapp.UseCase

      alias Dapp.Error
      alias Dapp.UseCase

      @doc false
      def success(dto \\ %{}), do: {:ok, dto}

      @doc false
      def fail(message), do: Error.new(message)

      def validate(args, _keys) when is_nil(args), do: fail("use case args must not be nil")

      @doc "Ensure use case args contain all required keys."
      def validate(args, keys) do
        if missing_keys?(args, keys) do
          fail("missing required args: #{inspect(keys)}")
        else
          :ok
        end
      end

      @doc false
      defp missing_keys?(map, keys) do
        Enum.any?(keys, fn key ->
          !Map.has_key?(map, key)
        end)
      end
    end
  end
end
