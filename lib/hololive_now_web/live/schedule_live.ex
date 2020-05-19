defmodule HololiveNowWeb.ScheduleLive do
  use HololiveNowWeb, :live_view
  alias HololiveNow.Schedule
  alias HololiveNowWeb.ScheduleView
  alias HololiveNowWeb.Endpoint

  @topic "update"

  def update() do
    IO.puts("update...")
    state = Schedule.all()
    Endpoint.broadcast(@topic, "update", %{ lives: state })
  end

  def render(assigns) do
    ScheduleView.render("index.html", assigns)
  end

  def handle_info(%{topic: @topic, payload: state}, socket) do
    {:noreply, assign(socket, state)}
  end

  @impl true
  def mount(_params, _session, socket) do
    lives = Schedule.all()
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
