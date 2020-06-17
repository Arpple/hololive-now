defmodule HololiveNow.WebImpl do
  @moduledoc false

  alias HololiveNow.Impl
  alias HololiveNow.Schedule

  @behaviour Impl

  def fetch_lives(), do: fetch_lives("")

  def fetch_lives(group) do
    lives = Schedule.all(group)
    {:ok, lives}
  end
end
