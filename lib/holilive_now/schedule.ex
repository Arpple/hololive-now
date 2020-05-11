defmodule HoliliveNow.Schedule do
  @url "https://schedule.hololive.tv/lives/hololive"
  
  def all() do
    %{body: body} = HTTPoison.get!(@url)

    containers = body
    |> Floki.parse_document!()
    |> Floki.find("#all .container")
    |> Enum.at(1)
    |> IO.inspect(limit: :infinity)
    nil
  end


  def read_container(container) do
    date = get_date(container)

    blocks = container
    |> Floki.find(".thumbnail .container .row")

    blocks

    # IO.inspect(length(blocks))

    # blocks
    # |> Enum.at(6) # only 1st for test
    # |> read_block()
  end

  def read_block(block) do
    [head, thumbnail, icons] = Floki.children(block)

    icons
  end
  
  def has_date?(group_container) do
    datetime = Floki.find(group_container, ".navbar-text")
    not Enum.empty?(datetime)
  end

  def get_date(group_container) do
    [date_str, _] = group_container
    |> Floki.find(".navbar-text")
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

  def get_blocks(container) do
    container
    |> Floki.find(".thumbnail .container")
    |> Enum.map(fn block -> block end)
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
