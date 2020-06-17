defmodule HololiveNow.Impl do
  @moduledoc false

  alias HololiveNow.Live

  @callback fetch_lives(String.t) :: {:ok, list(Live.t)} | {:error}
end
