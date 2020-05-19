defmodule HololiveNowWeb.ScheduleView do
  use HololiveNowWeb, :view

  alias HololiveNowWeb.ScheduleLive

  def date_str(date) do
    to_string(date.month) <> "/" <> to_string(date.day)
  end

  def time(datetime) do
    %{ hour: hour, minute: minute } = datetime
    time_str(hour) <> ":" <> time_str(minute)
  end

  defp time_str(int) do
    int
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

  def live_class(live) do
    case live.active? do
      true -> "live live-active"
      false -> "live"
    end
  end
end
