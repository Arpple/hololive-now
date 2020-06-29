defmodule HololiveNowWeb.ScheduleView do
  use HololiveNowWeb, :view

  alias HololiveNow.Live
  alias HololiveNow.LiveState

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
    case LiveState.get(live, now) do
      :future -> "live"
      :active -> "live live-active"
      :prepare -> "live live-prepare"
      :ended -> "live live-ended"
    end
  end

  def group_by_date(lives, tz) do
    lives
    |> Enum.group_by(fn %Live{ start_time: start_time } ->
      Timex.Timezone.convert(start_time, tz)
      |> DateTime.to_date()
    end)
    |> Enum.map(fn x -> x end) # convert to tuple to ensure ordering :\
  end

  def redirect_url(path, timezone) do
    path <> "?tz=" <> timezone
  end

  def nav_group_class(group, group), do: "nav-group-selected"
  def nav_group_class(_group, _other), do: ""
 end
