# Map a schema struct to a DTO.
defprotocol Dapp.Dto do
  @moduledoc """
  Create a data transfer object from a struct.
  """
  @spec from_schema(struct()) :: map()
  def from_schema(struct)
end
