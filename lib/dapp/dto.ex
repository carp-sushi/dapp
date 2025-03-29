defprotocol Dapp.Dto do
  @moduledoc """
  Create data transfer objects from a structs. A Dto is simply a map, created for the purpose
  of being serialized to JSON. Thus, all entries in the map must be able to be serialized to JSON.
  """
  @spec from_schema(struct()) :: map()
  def from_schema(struct)
end
