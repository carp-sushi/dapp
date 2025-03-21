defmodule Dapp do
  @moduledoc false
  use Application

  require Logger

  @port Application.compile_env(:dapp, :http_port, 8080)

  @impl true
  def start(_type, _args) do
    Logger.info("Running on port #{@port}")

    Supervisor.start_link(
      [Dapp.Repo, {Plug.Cowboy, scheme: :http, plug: Dapp.Plug, options: [port: @port]}],
      strategy: :one_for_one,
      name: Dapp.Supervisor
    )
  end
end
