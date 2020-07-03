defmodule HololiveNow do
  @moduledoc """
  """

  alias HololiveNow.{ Impl, WebImpl, Live }

  @behaviour Impl

  @spec fetch_lives() :: {:ok, list(Live.t)} | {:error}
  def fetch_lives() do
    impl().fetch_lives()
  end

  @spec fetch_lives(String.t) :: {:ok, list(Live.t)} | {:error}
  def fetch_lives(group) do
    impl().fetch_lives(group)
  end

  @spec get_live_state(Live.t, DateTime.t) :: LiveState.t
  def get_live_state(live, now) do
    impl().get_live_state(live, now)
  end

  defp impl() do
    Application.get_env(:hololive_now, :impl, WebImpl)
  end
end
