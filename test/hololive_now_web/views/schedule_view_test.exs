defmodule HololiveNowWeb.ScheduleViewTest do
  use ExUnit.Case
  alias HololiveNow.Live
  alias HololiveNowWeb.ScheduleView

  test "thumbnail url normal for ended live" do
    live = %Live{
      start_time: ~U[2000-01-01 12:00:00Z],
      active?: false,
      thumbnail: "image.jpg",
    }

    now = ~U[2000-01-01 13:00:00Z]

    assert ScheduleView.thumbnail_url(live, now) == "image.jpg"
  end

  test "thumbnail url contain query for future live" do
    live = %Live{
      start_time: ~U[2000-01-01 12:00:00Z],
      active?: false,
      thumbnail: "image.jpg",
    }

    now = ~U[2000-01-01 11:00:00Z]
    now_timestamp = "946724400"

    assert ScheduleView.thumbnail_url(live, now) == "image.jpg?q=" <> now_timestamp
  end

  test "display start time" do
    live = %Live{
      start_time: ~U[2000-01-01 12:03:00Z],
    }

    assert ScheduleView.time(live, "Asia/Tokyo") == "21:03"
  end

  test "display start time with timezone" do
    live = %Live{
      start_time: ~U[2000-01-01 12:03:00Z],
    }

    assert ScheduleView.time(live, "Asia/Bangkok") == "19:03"
  end

  test "get css class for ended live" do
    live = %Live{
      start_time: ~U[2000-01-01 12:00:00Z],
      active?: false,
    }

    now = ~U[2000-01-01 13:00:00Z]

    assert ScheduleView.live_class(live, now) == "live live-ended"
  end

  test "get css class for unsure ended live" do
    live = %Live{
      start_time: ~U[2000-01-01 12:00:00Z],
      active?: false,
    }

    now = ~U[2000-01-01 12:05:00Z]

    assert ScheduleView.live_class(live, now) == "live live-unsure"
  end

  test "get css class for active live" do
    live = %Live{
      start_time: ~U[2000-01-01 12:00:00Z],
      active?: true,
    }

    now = ~U[2000-01-01 13:00:00Z]

    assert ScheduleView.live_class(live, now) == "live live-active"
  end

  test "get css class for future live" do
    live = %Live{
      start_time: ~U[2000-01-01 12:00:00Z],
      active?: false,
    }

    now = ~U[2000-01-01 11:00:00Z]

    assert ScheduleView.live_class(live, now) == "live"
  end

  test "group lives by date of timezone" do
    live_1 = %Live{ start_time: ~U[2000-01-01 13:00:00Z] }
    live_2 = %Live{ start_time: ~U[2000-01-01 14:00:00Z] }
    live_3 = %Live{ start_time: ~U[2000-01-01 15:00:00Z] }
    live_4 = %Live{ start_time: ~U[2000-01-01 16:00:00Z] }

    group = ScheduleView.group_by_date([live_1, live_2, live_3, live_4], "Asia/Tokyo")

    assert [
      { ~D[2000-01-01], [^live_1, ^live_2] },
      { ~D[2000-01-02], [^live_3, ^live_4] },
    ] = group
  end

  test "create redirect url with timezone query" do
    assert ScheduleView.redirect_url("/", "Asia/Tokyo") == "/?tz=Asia/Tokyo"
    assert ScheduleView.redirect_url("/hololive", "Asia/Bangkok") == "/hololive?tz=Asia/Bangkok"
  end
end
