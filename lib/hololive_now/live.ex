defmodule HololiveNow.Live do
  defstruct [
      url: nil,
      start_time: nil,
      channel: nil,
      thumbnail: nil,
      icons: [],
      active?: false,
  ]

  def end?(%__MODULE__{active?: true}, _now), do: false
  
  def end?(%__MODULE__{start_time: start_time}, now) do
    Timex.compare(now, start_time) > 0
  end
end
