defmodule HololiveNow.Task do
  use Task

  @time 1000 * 10

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
