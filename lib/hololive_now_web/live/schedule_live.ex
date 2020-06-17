defmodule HololiveNowWeb.ScheduleLive do
  use HololiveNowWeb, :live_view

  alias HololiveNowWeb.ScheduleView
  alias Phoenix.PubSub
  alias HololiveNowWeb.Presence
  require Logger

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
    {:ok, lives} = HololiveNow.fetch_lives(group)

    topic = group
    |> get_topic()

    PubSub.subscribe(HololiveNow.PubSub, topic)
    Presence.track(self(), topic, socket.id, %{})

    {:ok, assign(socket, lives: lives, tz: tz, now: now, group: group)}
  end

  def update() do
    now = Timex.now()

    log_update()

    for group <- @all_groups do
      topic = get_topic(group)
      {:ok, lives} = HololiveNow.fetch_lives(group)
      PubSub.broadcast(HololiveNow.PubSub, topic, {:update, %{ lives: lives, now: now }})
    end
  end

  defp log_update() do
    user_count = @all_groups
    |> Enum.map(&get_topic/1)
    |> Enum.reduce(0, fn topic, count ->
      topic_count = topic
      |> Presence.list()
      |> Map.keys()
      |> length()

      count + topic_count
    end)

    IO.puts("update: users=" <> to_string(user_count))
  end

  @impl true
  def handle_info({:update, %{ lives: lives, now: now }}, socket) do
    {:noreply, assign(socket, lives: lives, now: now)}
  end

  def handle_info(%{ event: "presence_diff" }, socket) do
    {:noreply, socket}
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
