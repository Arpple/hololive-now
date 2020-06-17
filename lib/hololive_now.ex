defmodule HololiveNow do
  @moduledoc """
  """

  alias HololiveNow.Live
  alias HololiveNow.WebImpl

  @behaviour Impl

  @spec fetch_lives() :: {:ok, list(Live.t)} | {:error}
  def fetch_lives() do
    impl().fetch_lives()
  end

  @spec fetch_lives(String.t) :: {:ok, list(Live.t)} | {:error}
  def fetch_lives(group) do
    impl().fetch_lives(group)
  end

  defp impl() do
    Application.get_env(:hololive_now, :impl, WebImpl)
  end
end
