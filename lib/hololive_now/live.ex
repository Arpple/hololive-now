defmodule HololiveNow.Live do
  defstruct [
      url: nil,
      start_time: nil,
      channel: nil,
      thumbnail: nil,
      icons: [],
      active?: false,
  ]

  @type t :: %__MODULE__{
    url: String.t,
    start_time: DateTime.t,
    channel: String.t,
    thumbnail: String.t,
    icons: list(String.t),
    active?: boolean,
  }

  def state(%__MODULE__{ active?: true }, _now), do: :active

  def state(%__MODULE__{ start_time: start_time }, now) do
    case Timex.compare(now, start_time) do
      -1 -> :future

      _ ->
        diff = now
        |> Timex.diff(start_time, :minute)
        |> abs()

        if diff < 15 do
          :prepare
        else
          :ended
        end
    end
  end
end
