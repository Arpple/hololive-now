defmodule HoliliveNow.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      HoliliveNow.Repo,
      # Start the Telemetry supervisor
      HoliliveNowWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HoliliveNow.PubSub},
      # Start the Endpoint (http/https)
      HoliliveNowWeb.Endpoint,
      # Start a worker by calling: HoliliveNow.Worker.start_link(arg)
      # {HoliliveNow.Worker, arg}
      HololiveNow.Task,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HoliliveNow.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HoliliveNowWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
