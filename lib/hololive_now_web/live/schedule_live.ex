defmodule HololiveNowWeb.ScheduleLive do
  use HololiveNowWeb, :live_view
  alias HololiveNow.Schedule
  alias HololiveNowWeb.ScheduleView
  alias HololiveNowWeb.Endpoint
  require Logger

  @topic "update"

  def update() do
    state = Schedule.all()
    Endpoint.broadcast(@topic, "update", %{ lives: state })
  end

  @impl true
  def render(assigns) do
    ScheduleView.render("index.html", assigns)
  end

  @impl true
  def handle_info(%{topic: @topic, payload: state}, socket) do
    {:noreply, assign(socket, state)}
  end

  @impl true
  def mount(params, _session, socket) do
    group = params["group"]
    lives = Schedule.all(group)
    Endpoint.subscribe(@topic)

    {:ok, assign(socket, lives: lives)}
  end

  # for test
  defp remove_active(date_group) do
    Map.put(date_group, :lives, Enum.map(date_group.lives, fn l ->
          Map.put(l, :active?, false)
    end))
  end

  defp force_active(date_group) do
    Map.put(date_group, :lives, Enum.map(date_group.lives, fn l ->
          Map.put(l, :active?, true)
    end))
  end
end
