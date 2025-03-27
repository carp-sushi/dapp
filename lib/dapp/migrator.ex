defmodule Dapp.Migrator do
  @moduledoc """
  Runs ecto migrations.
  """
  require Application

  def run do
    {:ok, _} = Application.ensure_all_started(:dapp)
    path = Application.app_dir(:dapp, "priv/repo/migrations")
    Ecto.Migrator.run(Dapp.Repo, path, :up, all: true)
    :init.stop()
  end
end
