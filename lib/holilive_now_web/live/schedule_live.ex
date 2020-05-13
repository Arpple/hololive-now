defmodule HoliliveNowWeb.ScheduleLive do
  use HoliliveNowWeb, :live_view
  alias HoliliveNow.Schedule
  alias HoliliveNowWeb.ScheduleView

  def render(assigns) do
    ScheduleView.render("index.html", assigns)
  end

  @impl true
  def mount(_params, _session, socket) do
    lives = Schedule.all()
    {:ok, assign(socket, lives: lives)}
  end
end
