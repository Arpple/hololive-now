defmodule HololiveNow.WebImpl do
  @moduledoc false

  alias HololiveNow.Impl
  alias HololiveNow.Schedule
  alias HololiveNow.Live
  alias HololiveNow.WebImpl.GroupContainer

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
    |> flatten_dategroup()

    {:ok, lives}
  end

  def convert_to_lives(blocks) do
    Enum.map(blocks, fn block ->
      lives = Enum.map(block.containers, fn container -> read_container(block.date, container) end)
      %{ date: block.date, lives: lives }
    end)
  end

  def flatten_dategroup(date_groups) do
    date_groups
    |> Enum.flat_map(fn group -> group.lives end)
  end

  def read_container(date, container_a) do
    [container] = Floki.find(container_a, ".container")
    [row] = Floki.children(container)
    [head, thumbnail, icons] = Floki.children(row)

    {:ok, ndatetime} = NaiveDateTime.new(date, get_time(head))
    datetime = DateTime.from_naive!(ndatetime, "Asia/Tokyo")

    %Live{
      url: get_url(container_a),
      start_time: datetime,
      channel: get_channel(head),
      thumbnail: get_thumbnail_url(thumbnail),
      icons: get_icons_url(icons),
      active?: active?(container_a),
    }
  end

  def get_time(head) do
    [hour, min] = head
    |> Floki.find(".datetime")
    |> Floki.text()
    |> String.trim()
    |> String.split(":")
    |> Enum.map(&Util.parse_int/1)

    {:ok, time} = Time.new(hour, min, 0)
    time
  end

  def get_channel(head) do
    head
    |> Floki.find(".name")
    |> Floki.text()
    |> String.trim()
  end

  def get_thumbnail_url(thumbnail) do
    [url] = thumbnail
    |> Floki.find("img")
    |> Floki.attribute("src")

    url
  end

  def get_icons_url(icons) do
    icons
    |> Floki.find("img")
    |> Enum.map(fn img ->
      [src] = Floki.attribute(img, "src")
      src
    end)
  end

  def get_url(container) do
    [url] = Floki.attribute(container, "href")
    url
  end

  def active?(container_a) do
    [style] = Floki.attribute(container_a, "style")
    String.contains?(style, "red")
  end
end
