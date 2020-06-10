defmodule HololiveNowWeb.Task.KeepAlive do
  use Task

  # 30 sec
  @time 1000 * 30

  def start_link(_arg) do
    Task.start_link(&run/0)
  end

  def run() do
    receive do
    after @time ->
      HololiveNowWeb.ScheduleLive.keep_alive()
      run()
    end
  end
end
