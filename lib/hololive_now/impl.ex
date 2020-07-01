defmodule HololiveNow.Impl do
  @moduledoc false

  alias HololiveNow.Live
  alias HololiveNow.LiveState

  @type result :: {:ok, list(Live.t)} | {:error}

  @callback fetch_lives() :: result
  @callback fetch_lives(String.t) :: result
  
  @callback get_live_state(Live.t, DateTime.t) :: LiveState.t
end
