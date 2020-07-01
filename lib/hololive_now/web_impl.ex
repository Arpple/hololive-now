defmodule HololiveNow.WebImpl do
  @moduledoc false

  alias HololiveNow.Impl
  alias HololiveNow.Schedule
  alias HololiveNow.Live
  alias HololiveNow.WebImpl.{ GroupContainer, Container }

  @behaviour Impl

  @url "https://schedule.hololive.tv/lives"

  def fetch_lives(), do: fetch_lives_from(@url)
  def fetch_lives(""), do: fetch_lives_from(@url)
  def fetch_lives(group), do: fetch_lives_from(@url <> "/" <> group)

  defp fetch_lives_from(url) do
    %{body: body} = HTTPoison.get!(url)

    lives = body
    |> Floki.parse_document!()
    |> Floki.find("#all .container")
    |> GroupContainer.from_container_divs()
    |> convert_to_lives()

    {:ok, lives}
  end

  def convert_to_lives(group_containers) do
    Enum.flat_map(group_containers, fn group ->
      Enum.map(group.containers, fn container -> Container.to_live(group.date, container) end)
    end)
  end

  @prepare_minutes 15
  def get_live_state(%Live{ active?: true }, _now), do: :active

  def get_live_state(%Live{ start_time: start_time }, now) do
    case Timex.compare(now, start_time) do
      -1 -> :future

      _ ->
        diff = now
        |> Timex.diff(start_time, :minute)
        |> abs()

        if diff < @prepare_minutes do
          :prepare
        else
          :ended
        end
    end
  end
end
