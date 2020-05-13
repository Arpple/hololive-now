defmodule HoliliveNow.Schedule do
  @url "https://schedule.hololive.tv/lives/hololive"
  
  def all() do
    %{body: body} = HTTPoison.get!(@url)

    group_containers = body
    |> Floki.parse_document!()
    |> Floki.find("#all .container")
    |> read_group_containers()
    |> convert_to_lives()
  end

  def read_group_containers(group_containers) do
    list = Enum.reduce(group_containers, [], fn group_container, acc ->
      if has_date?(group_container) do
        block = %{
          date: get_date(group_container),
          containers: get_containers(group_container),
        }

        [block | acc]
      else
        [block | rem] = acc
        [ %{block | containers: block.containers ++ get_containers(group_container)} | rem ]
      end
    end)

    Enum.reverse(list)
  end

  def convert_to_lives(blocks) do
    Enum.map(blocks, fn block ->
      lives = Enum.map(block.containers, fn container -> read_container(block.date, container) end)
      %{ date: block.date, lives: lives }
    end)
  end

  def read_container(date, container) do
    [row] = Floki.children(container)
    [head, thumbnail, icons] = Floki.children(row)
    {:ok, datetime} = NaiveDateTime.new(date, get_time(head))
    %{
      datetime: datetime,
      channel: get_channel(head),
      thumbnail: get_thumbnail_url(thumbnail),
      icons: get_icons_url(icons),
    }
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

  def get_containers(group_container) do
    group_container
    |> Floki.find(".thumbnail .container")
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
end
