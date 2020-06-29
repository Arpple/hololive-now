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
end
