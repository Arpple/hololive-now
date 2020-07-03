defmodule HololiveNow.WebImplTest do
  use ExUnit.Case

  alias HololiveNow.{ Live, WebImpl }

  test "live state is :future when not reach start time yet" do
    live = %Live{
      active?: false,
      start_time: ~U[2000-01-01 12:00:00Z],
    }

    now = ~U[2000-01-01 11:00:00Z]

    assert WebImpl.get_live_state(live, now) == :future
  end

  test "live state is :active when status active" do
    live = %Live{
      active?: true,
      start_time: ~U[2000-01-01 12:00:00Z],
    }

    now = ~U[2000-01-01 12:05:00Z]

    assert WebImpl.get_live_state(live, now) == :active
  end

  test "live state is :prepare when status not active but just start for lower than 15 minutes" do
    live = %Live{
      active?: false,
      start_time: ~U[2000-01-01 12:00:00Z],
    }

    now = ~U[2000-01-01 12:10:00Z]

    assert WebImpl.get_live_state(live, now) == :prepare
  end

  test "live state is :ended when status not active and pass the start time over 15 minutes" do
    live = %Live{
      active?: false,
      start_time: ~U[2000-01-01 12:00:00Z],
    }

    now = ~U[2000-01-01 12:16:00Z]

    assert WebImpl.get_live_state(live, now) == :ended
  end
end
