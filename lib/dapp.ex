defmodule Dapp do
  @moduledoc false
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("Starting dApp...")

    Supervisor.start_link(
      [Dapp.Repo, {Plug.Cowboy, scheme: :http, plug: Dapp.Plug, options: [port: 8081]}],
      strategy: :one_for_one,
      name: Dapp.Supervisor
    )
  end
end
