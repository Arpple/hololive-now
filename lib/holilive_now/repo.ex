defmodule HoliliveNow.Repo do
  use Ecto.Repo,
    otp_app: :holilive_now,
    adapter: Ecto.Adapters.Postgres
end
