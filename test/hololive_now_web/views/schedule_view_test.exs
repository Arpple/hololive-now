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

  test "get css class for end live" do
    live = %Live{
      start_time: ~U[2000-01-01 12:00:00Z],
      active?: false,
    }

    now = ~U[2000-01-01 13:00:00Z]

    assert ScheduleView.live_class(live, now) == "live live-ended"
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
end
