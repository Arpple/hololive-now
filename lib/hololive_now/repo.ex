defmodule HololiveNow.Repo do
  use Ecto.Repo,
    otp_app: :hololive_now,
    adapter: Ecto.Adapters.Postgres
end
