defmodule HololiveNow.WebImpl.Container do
  @moduledoc false

  alias HololiveNow.Live
  
  def to_live(date, container) do
    [sub_container] = Floki.find(container, ".container")
    [row] = Floki.children(sub_container)
    [head, thumbnail, icons] = Floki.children(row)

    {:ok, ndatetime} = NaiveDateTime.new(date, get_time(head))
    datetime = DateTime.from_naive!(ndatetime, "Asia/Tokyo")

    %Live{
      url: get_url(container),
      start_time: datetime,
      channel: get_channel(head),
      thumbnail: get_thumbnail_url(thumbnail),
      icons: get_icons_url(icons),
      active?: active?(container),
    }
  end
  
  defp get_channel(head) do
    head
    |> Floki.find(".name")
    |> Floki.text()
    |> String.trim()
  end

  defp get_thumbnail_url(thumbnail) do
    [url] = thumbnail
    |> Floki.find("img")
    |> Floki.attribute("src")

    url
  end

  defp get_icons_url(icons) do
    icons
    |> Floki.find("img")
    |> Enum.map(fn img ->
      [src] = Floki.attribute(img, "src")
      src
    end)
  end

  defp get_url(container) do
    [url] = Floki.attribute(container, "href")
    url
  end
  
  defp get_time(head) do
    [hour, min] = head
    |> Floki.find(".datetime")
    |> Floki.text()
    |> String.trim()
    |> String.split(":")
    |> Enum.map(&Util.parse_int/1)

    {:ok, time} = Time.new(hour, min, 0)
    time
  end

  defp active?(container_a) do
    [style] = Floki.attribute(container_a, "style")
    String.contains?(style, "red")
  end
end
