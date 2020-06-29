defmodule HololiveNow.LiveState do
  @type t :: :ended | :preparing | :active | :future

  alias HololiveNow.Live

  @prepare_minutes 15

  @spec get(Live.t, DateTime.t) :: t
  def get(%Live{ active?: true }, _now), do: :active

  def get(%Live{ start_time: start_time }, now) do
    case Timex.compare(now, start_time) do
      -1 -> :future

      _ ->
        diff = now
        |> Timex.diff(start_time, :minute)
        |> abs()

        if diff < @prepare_minutes do
          :prepare
        else
          :ended
        end
    end
  end
end
