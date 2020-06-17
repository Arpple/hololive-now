defmodule HololiveNow.DefaultImpl do
  alias HololiveNow.Impl
  alias HololiveNow.Schedule

  @behaviour Impl

  @spec fetch_lives(String.t) :: {:ok, list(Live.t)} | {:error}
  def fetch_lives(group) do
    lives = Schedule.all(group)
    {:ok, lives}
  end
end
