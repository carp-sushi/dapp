defmodule Mix.Tasks.Migrate do
  @moduledoc """
  A custom mix task that runs ecto migrations.
  """
  use Mix.Task
  require Application

  def run(_) do
    {:ok, _} = Application.ensure_all_started(:dapp)
    path = Application.app_dir(:dapp, "priv/repo/migrations")
    Ecto.Migrator.run(Dapp.Repo, path, :up, all: true)
    :init.stop()
  end
end
