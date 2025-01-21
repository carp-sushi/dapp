defmodule Dapp.Data.Spec.RoleRepoSpec do
  @moduledoc """
  Data layer specification for managing roles.
  """
  alias Dapp.Data.Schema.Role
  @callback all :: list(Role.t())
end
