defmodule Dapp do
  @moduledoc false
  use Application
  require Logger

  @port Application.compile_env(:dapp, :http_port, 8080)

  @job_queue_disabled Application.compile_env(:dapp, :job_queue_disabled, false)

  @impl true
  def start(_type, _args) do
    Logger.info("Running on port #{@port}")

    build_children()
    |> Supervisor.start_link(strategy: :one_for_one, name: Dapp.Supervisor)
  end

  # Determine whether to start the job queue
  defp build_children do
    children = [Dapp.Repo, {Plug.Cowboy, scheme: :http, plug: Dapp.Plug, options: [port: @port]}]

    case @job_queue_disabled do
      true -> children
      false -> List.insert_at(children, 1, {Dapp.JobQueue, repo: Dapp.Repo})
    end
  end
end
