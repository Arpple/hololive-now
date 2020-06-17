defmodule HololiveNow do
  @moduledoc """
  """

  alias HololiveNow.Live
  alias HololiveNow.DefaultImpl

  @behaviour HololiveNow.Impl

  @spec fetch_lives(String.t) :: {:ok, list(Live.t)} | {:error}
  def fetch_lives(group) do
    impl().fetch_lives(group)
  end

  defp impl() do
    Application.get_env(:hololive_now, :impl, DefaultImpl)
  end
end
