defmodule Dapp do
  @moduledoc """
  The application entry point.
  """
  use Application

  require Logger

  @port Application.compile_env(:dapp, :http_port, 8080)

  @impl true
  def start(_type, _args) do
    Logger.info("Running on port #{@port}")

    children = [
      Dapp.Repo,
      {Bandit, plug: Dapp.Plug, port: @port}
    ]

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: Dapp.Supervisor
    )
  end
end
