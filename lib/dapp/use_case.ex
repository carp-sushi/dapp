defmodule Dapp.UseCase do
  @moduledoc """
  Defines use case behaviour.
  """
  @callback execute(args :: map) :: {:ok, dto :: map} | {:error, error :: map}
end
