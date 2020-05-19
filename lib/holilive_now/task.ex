defmodule HololiveNow.Task do
  use Task

  # 1 minute
  @time 1000 * 60

  def start_link(_arg) do
    Task.start_link(&run/0)
  end

  def run() do
    receive do
    after @time ->
      HoliliveNowWeb.ScheduleLive.update()
      run()
    end
  end
end
