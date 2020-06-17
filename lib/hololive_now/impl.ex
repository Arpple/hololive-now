defmodule HololiveNow.Impl do
  @moduledoc false

  alias HololiveNow.Live

  @type result :: {:ok, list(Live.t)} | {:error}

  @callback fetch_lives() :: result
  @callback fetch_lives(String.t) :: result
end
