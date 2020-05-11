defmodule HoliliveNow.ScheduleTest do
  use ExUnit.Case

  alias HoliliveNow.Schedule
  alias HoliliveNow.ScheduleCase

  test "check for group container has date header" do
    group_container = ScheduleCase.date_group_container()
    assert Schedule.has_date?(group_container)
  end

  test "check for group container not have date header" do
    group_container = ScheduleCase.content_group_container()
    assert not Schedule.has_date?(group_container)
  end

  test "get date from group container" do
    date =
      ScheduleCase.date_group_container()
      |>Schedule.get_date()

    assert date == ~D[2020-05-11]
  end

  test "get containers from group container" do
    blocks =
      ScheduleCase.date_group_container()
      |> Schedule.get_blocks()

    assert length(blocks) == 4
  end

#   test "split containers into date group" do
#     containers = ScheduleCase.containers()

#     [date_10_containers, date_11_containers] =
#       ScheduleCase.containers()
#       |> Schedule.split_containers()

#     assert date_10_containers.date == ~D[2020-05-10]
#     assert length(date_10_containers.containers) == 5

#     assert date_11_containers.date == ~D[2020-05-11]
#     assert length(date_11_containers.containers) == 4
#   end

#   test "get container date" do
#     container = ScheduleCase.container()
#     date = Schedule.get_date(container)
#     assert date == ~D[2020-05-10]
#   end

#   test "get head block channel" do
#     head = ScheduleCase.head()
#     channel = Schedule.get_channel(head)
#     assert channel == "百鬼あやめ"
#   end

#   test "get head block live time" do
#     date = ~D[2020-05-10]
#     head = ScheduleCase.head()
#     time = Schedule.get_time(head, date)
#     assert time == ~N[2020-05-10 00:02:00]
#   end

#   test "get thumbnail block thumbnail url" do
#     thumbnail = ScheduleCase.thumbnail()
#     url = Schedule.get_thumbnail_url(thumbnail)
#     assert url == "https://img.youtube.com/vi/7ePTTaERAF8/mqdefault.jpg"
#   end
end
