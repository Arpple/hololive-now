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

  test "get containers from group container with date" do
    containers =
      ScheduleCase.date_group_container()
      |> Schedule.get_containers()

    assert length(containers) == 4
  end

  test "get containers from group containre without date" do
    containers =
      ScheduleCase.content_group_container()
      |> Schedule.get_containers()

    assert length(containers) == 1
  end

  test "get time from head col" do
    time =
      ScheduleCase.col_head()
      |> Schedule.get_time()

    assert time == ~T[00:01:00]
  end
  
  test "get channel name from head col" do
    channel =
      ScheduleCase.col_head()
      |> Schedule.get_channel()
    assert channel == "宝鐘マリン"
  end

  test "get thumbnail url from thumbnail col" do
    url =
      ScheduleCase.col_thumbnail()
      |> Schedule.get_thumbnail_url()
    
    assert url == "https://img.youtube.com/vi/gliXPuiGjFU/mqdefault.jpg"
  end

  test "get icons url from icon col" do
    [icon] =
      ScheduleCase.col_icons()
      |> Schedule.get_icons_url()

    assert icon == "https://yt3.ggpht.com/a/AGF-l7_dX9d8sMDya_L_ApF7pxUSiwtSOId7Bufd-g=s88-c-k-c0xffffffff-no-rj-mo"
  end

  test "get multiple icons url from icon col" do
    [icon_1, icon_2] =
      ScheduleCase.col_icons_multi()
      |> Schedule.get_icons_url()

    assert icon_1 == "https://yt3.ggpht.com/a/AGF-l78pYNGWXckjVjmMsSz4iPeCzmWB2DHFW3lLdQ=s88-c-k-c0xffffffff-no-rj-mo"
    assert icon_2 == "https://yt3.ggpht.com/a/AGF-l7-UWVGytfW-cAiCvg8r2C_6Gk2SnqSkJP9Cqg=s88-c-k-c0xffffffff-no-rj-mo"
  end
end
