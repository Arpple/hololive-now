defmodule HololiveNowWeb.ScheduleView do
  use HololiveNowWeb, :view

  alias HololiveNowWeb.ScheduleLive
  alias HololiveNow.Live

  def thumbnail_url(%Live{start_time: start_time, thumbnail: thumbnail}) do
    now = Timex.now()    
    case Timex.compare(now, start_time) do
      # live in future
      -1 -> thumbnail <> "?q=" <> Integer.to_string(DateTime.to_unix(now))
      _ -> thumbnail
    end
  end

  def date_str(date) do
    to_string(date.month) <> "/" <> to_string(date.day)
  end

  def time(datetime, tz) do
    %{ hour: hour, minute: minute } = datetime
    
    Timex.Timezone.convert(datetime, tz)
    |> Timex.format!("%H:%M", :strftime)
  end

  defp time_str(int) do
    int
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

  def live_class(live) do
    "live"
    |> active_class(live)
    |> past_class(live)
  end

  defp active_class(class, %{active?: true}), do: class <> " live-active"
  defp active_class(class, _live), do: class

  defp past_class(class, %{active?: true}), do: class
  
  defp past_class(class, %Live{} = live) do
    now = Timex.now()
    case Live.end?(live, now) do
      true -> class <> " live-past"
      _ -> class
    end
  end
 end
