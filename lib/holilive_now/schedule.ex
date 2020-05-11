defmodule HoliliveNow.Schedule do
  @url "https://schedule.hololive.tv/lives/hololive"
  
  def all() do
    %{body: body} = HTTPoison.get!(@url)

    containers = body
    |> Floki.parse_document!()
    |> Floki.find("#all")
    |> Enum.at(0)
    |> Floki.children()

    containers
    |> Enum.at(0) # only 1st for test
    |> read_container()
  end

  def read_container(container) do
    date = get_date(container)

    blocks = container
    |> Floki.find(".thumbnail .container .row")

    blocks
    |> Enum.at(0) # only 1st for test
    |> read_block()
  end

  def read_block(block) do
    [head, thumbnail, icons] = Floki.children(block)

    thumbnail
  end

  def get_date(container) do
    [date_str, _] = container
    |> Floki.children()
    |> Enum.at(0)
    |> Floki.children()
    |> Enum.at(0)
    |> Floki.text()
    |> String.trim()
    |> String.split("\n")

    [month, date] = date_str
    |> String.trim()
    |> String.split("/")
    |> Enum.map(&Util.parse_int/1)

    year = DateTime.utc_now().year

    {:ok, date} = Date.new(year, month, date)
    date
  end

  def get_time(head, date) do
    [hour, min] = head
    |> Floki.find(".datetime")
    |> Floki.text()
    |> String.trim()
    |> String.split(":")
    |> Enum.map(&Util.parse_int/1)

    {:ok, time} = Time.new(hour, min, 0)
    {:ok, datetime} = NaiveDateTime.new(date, time)
    datetime
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

  end
end
