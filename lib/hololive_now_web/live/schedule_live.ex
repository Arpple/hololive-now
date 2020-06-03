defmodule HololiveNowWeb.ScheduleLive do
  use HololiveNowWeb, :live_view
  alias HololiveNow.Schedule
  alias HololiveNowWeb.ScheduleView
  alias HololiveNowWeb.Endpoint
  require Logger

  @event_update "update"

  @all_groups [
    nil,
    "hololive",
    "holostars",
    "innk",
    "china",
    "indonesia",
  ]

  def update() do
    for group <- @all_groups do
      topic = group_topic(group)
      state = Schedule.all(topic)
      Endpoint.broadcast(topic, @event_update, %{ lives: state })
    end
  end

  @impl true
  def render(assigns) do
    ScheduleView.render("index.html", assigns)
  end

  @impl true
  def handle_info(%{event: @event_update, payload: %{ lives: lives }}, socket) do
    {:noreply, assign(socket, lives: lives)}
  end

  @impl true
  def mount(params, _session, socket) do
    group = params["group"]
    lives = Schedule.all(group)
    tz = params["tz"] || "Asia/Tokyo"

    group
    |> group_topic()
    |> Endpoint.subscribe()

    {:ok, assign(socket, lives: lives, tz: tz)}
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

  defp group_topic(nil), do: ""
  defp group_topic(group), do: group
end
