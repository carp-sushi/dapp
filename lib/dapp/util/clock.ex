defmodule Dapp.Util.Clock do
  @moduledoc "Date and time helpers"
  def now do
    NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
  end
end
