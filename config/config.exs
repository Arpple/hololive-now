# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# config :hololive_now,
#   ecto_repos: [HololiveNow.Repo]

# Configures the endpoint
config :hololive_now, HololiveNowWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2B2SXjhW0h1ESHTEt6JFrlJ440upBYzsUiV9E8UnjfG2RB5fTYLv8BstCt9JAmhN",
  render_errors: [view: HololiveNowWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HololiveNow.PubSub,
  live_view: [signing_salt: "RdfUSRSt"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :husky,
    pre_push: "mix test"
