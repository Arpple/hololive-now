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

  @impl true
  def render(assigns) do
    ScheduleView.render("index.html", assigns)
  end

  @impl true
  def mount(params, _session, socket) do
    group = params["group"]
    tz = params["tz"] || "Asia/Tokyo"

    now = Timex.now()
    lives = Schedule.all(group)

    group
    |> get_topic()
    |> Endpoint.subscribe()

    {:ok, assign(socket, lives: lives, tz: tz, now: now)}
  end

  def update() do
    now = Timex.now()
    IO.puts(DateTime.to_string(now) <> " update")

    for group <- @all_groups do
      topic = get_topic(group)
      lives = Schedule.all(group)
      Endpoint.broadcast(topic, @event_update, %{ lives: lives, now: now })
    end
  end

  @impl true
  def handle_info(%{event: @event_update, payload: %{ lives: lives, now: now }}, socket) do
    {:noreply, assign(socket, lives: lives, now: now)}
  end

  # for test
  defp remove_active(lives) do
    Enum.map(lives, fn live ->
      Map.put(live, :active?, false)
    end)
  end

  defp force_active(lives) do
    Enum.map(lives, fn live ->
      Map.put(live, :active?, true)
    end)
  end

  defp get_topic(nil), do: ""
  defp get_topic(group), do: group
end
