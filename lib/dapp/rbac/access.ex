defmodule Dapp.Rbac.Access do
  @moduledoc """
  Controls access to protected routes.
  """
  use Dapp.Data.Keeper

  import Plug.Conn

  alias Dapp.Http.Response

  # When not provided explicitly, allow access to users with these roles.
  @default_roles ["Admin", "User"]

  @doc "Handle white-listed roles."
  def init(opts) do
    if is_nil(opts[:roles]) do
      opts ++ [roles: @default_roles]
    else
      opts
    end
  end

  @doc "Check user access for a request."
  def call(conn, opts) do
    if Map.has_key?(conn.assigns, :user) do
      check_user_access(conn, opts, conn.assigns.user)
    else
      Response.unauthorized(conn)
    end
  end

  # Check user role vs allowed roles.
  defp check_user_access(conn, opts, user) do
    if user.role.name in opts[:roles] do
      assign(conn, :role, user.role.name)
    else
      Response.unauthorized(conn)
    end
  end

  @doc "Only allow the admin role to access a route."
  def admin(conn, route) do
    if Map.get(conn.assigns, :role) == "Admin" do
      route.()
    else
      Response.unauthorized(conn)
    end
  end
end
