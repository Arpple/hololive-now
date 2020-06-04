defmodule HololiveNowWeb.ScheduleView do
  use HololiveNowWeb, :view

  alias HololiveNow.Live

  def thumbnail_url(%Live{start_time: start_time, thumbnail: thumbnail}, now) do
    case Timex.compare(now, start_time) do
      # live in future
      -1 -> thumbnail <> "?q=" <> Integer.to_string(DateTime.to_unix(now))
      _ -> thumbnail
    end
  end

  def date_str(date) do
    to_string(date.month) <> "/" <> to_string(date.day)
  end

  def time(%Live{ start_time: datetime }, tz) do
    Timex.Timezone.convert(datetime, tz)
    |> Timex.format!("%H:%M", :strftime)
  end

  def live_class(live, now) do
    "live"
    |> active_class(live)
    |> past_class(live, now)
  end

  defp active_class(class, %{active?: true}), do: class <> " live-active"
  defp active_class(class, _live), do: class

  defp past_class(class, %Live{active?: true}, _now), do: class
  defp past_class(class, %Live{} = live, now) do
    case Live.end?(live, now) do
      true -> class <> " live-ended"
      _ -> class
    end
  end
 end
