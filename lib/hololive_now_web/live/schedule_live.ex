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
    "english",
  ]

  @impl true
  def render(assigns) do
    ScheduleView.render("index.html", assigns)
  end

  @impl true
  def mount(params, _session, socket) do
    topic = params["group"]
    |> get_topic()

    tz = params["tz"] || "Asia/Tokyo"
    now = Timex.now()

    {:ok, lives} = HololiveNow.fetch_lives(topic)

    PubSub.subscribe(HololiveNow.PubSub, topic)
    Presence.track(self(), topic, socket.id, %{})

    {:ok, assign(socket, lives: lives, tz: tz, now: now, topic: topic)}
  end

  def update() do
    now = Timex.now()

    user_count = @all_groups
    |> Enum.map(&get_topic/1)
    |> Enum.reduce(0, fn topic, count ->
      case count_topic_user(topic) do
        0 -> count
        topic_count ->
          {:ok, lives} = HololiveNow.fetch_lives(topic)
          PubSub.broadcast(HololiveNow.PubSub, topic, {:update, %{ lives: lives, now: now }})
          count + topic_count
      end
    end)

    IO.puts("update: users=" <> to_string(user_count))

    :ok
  end

  defp count_topic_user(topic) do
    topic
    |> Presence.list()
    |> Map.keys()
    |> length()
  end

  @impl true
  def handle_info({:update, %{ lives: lives, now: now }}, socket) do
    {:noreply, assign(socket, lives: lives, now: now)}
  end

  def handle_info(%{ event: "presence_diff" }, socket) do
    {:noreply, socket}
  end

  defp get_topic(nil), do: ""
  defp get_topic(group), do: group
end
