defmodule HololiveNowWeb.Task.Update do
  use GenServer

  # 1 minute
  @time 1000 * 60

  def init(_state), do: {:ok, nil}

  def start_link(opts) do
    {:ok, pid} = GenServer.start_link(__MODULE__, opts)
    :timer.apply_interval(@time, __MODULE__, :run, [])
    {:ok, pid}
  end

  def run() do
    HololiveNowWeb.ScheduleLive.update()
  end
end
