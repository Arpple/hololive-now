defmodule HoliliveNowWeb.ScheduleLive do
  use HoliliveNowWeb, :live_view
  alias HoliliveNow.Schedule
  alias HoliliveNowWeb.ScheduleView
  alias HoliliveNowWeb.Endpoint

  @topic "update"

  def update() do
    state = Schedule.all()
    Endpoint.broadcast(@topic, "update", %{ lives: state })
  end

  def render(assigns) do
    ScheduleView.render("index.html", assigns)
  end

  def handle_info(%{topic: @topic, payload: state}, socket) do
    IO.inspect("wow")
    {:noreply, assign(socket, state)}
  end

  @impl true
  def mount(_params, _session, socket) do
    lives = Schedule.all()
    Endpoint.subscribe(@topic)

    {:ok, assign(socket, lives: lives)}
  end
end
