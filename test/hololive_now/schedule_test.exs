defmodule HoliliveNow.ScheduleTest do
  use ExUnit.Case

  alias HoliliveNow.Schedule
  alias HoliliveNow.ScheduleCase

  test "get container date" do
    container = ScheduleCase.container()
    date = Schedule.get_date(container)
    assert date == ~D[2020-05-10]
  end

  test "get head block channel" do
    head = ScheduleCase.head()
    channel = Schedule.get_channel(head)
    assert channel == "百鬼あやめ"
  end

  test "get head block live time" do
    date = ~D[2020-05-10]
    head = ScheduleCase.head()
    time = Schedule.get_time(head, date)
    assert time == ~N[2020-05-10 00:02:00]
  end

  test "get thumbnail block thumbnail url" do
    thumbnail = ScheduleCase.thumbnail
    url = Schedule.get_thumbnail_url(thumbnail)
    assert url == "https://img.youtube.com/vi/7ePTTaERAF8/mqdefault.jpg"
  end
end
