defmodule HololiveNow.Live do
  defstruct [
      url: nil,
      start_time: nil,
      channel: nil,
      thumbnail: nil,
      icons: [],
      active?: false,
  ]

  def state(%__MODULE__{ active?: true }, _now), do: :active
  
  def state(%__MODULE__{ start_time: start_time }, now) do
    case Timex.compare(now, start_time) do
      -1 -> :future

      _ ->
        diff = now
        |> Timex.diff(start_time, :minute)
        |> abs()
        
        if diff < 15 do
          :unsure
        else
          :ended
        end
    end
  end
end
