defmodule Dapp.JobQueue do
  @moduledoc false
  use EctoJob.JobQueue, table_name: "jobs"
  require Logger

  def perform(multi = %Ecto.Multi{}, params) do
    Logger.debug("running job; params = #{inspect(params)}")
    Dapp.Repo.transaction(multi)
  end
end
