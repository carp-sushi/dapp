defmodule Dapp.Util.Clock do
  @moduledoc "Date and time helpers"
  def now do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
  end
end
