defmodule HololiveNow.LiveTest do
  use ExUnit.Case
  alias HololiveNow.Live

  test "end? is true when not active and pass start time" do
    live = %Live{
      active?: false,
      start_time: ~U[2000-01-01 12:00:00Z],
    }

    now = ~U[2000-01-01 13:00:00Z]

    assert Live.end?(live, now)
  end

  test "end? is false when not active and not start yet" do
    live = %Live{
      active?: false,
      start_time: ~U[2000-01-01 12:00:00Z],
    }

    now = ~U[2000-01-01 11:00:00Z]

    assert not Live.end?(live, now)
  end

  test "end? is false when live is active" do
    live = %Live{
      active?: true,
      start_time: ~U[2000-01-01 12:00:00Z],
    }

    now = ~U[2000-01-01 13:00:00Z]

    assert not Live.end?(live, now)
  end
end
