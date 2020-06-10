defmodule HololiveNow.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # HololiveNow.Repo,
      # Start the Telemetry supervisor
      HololiveNowWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HololiveNow.PubSub},
      # Start the Endpoint (http/https)
      HololiveNowWeb.Endpoint,
      # Start a worker by calling: HololiveNow.Worker.start_link(arg)
      # {HololiveNow.Worker, arg}
      HololiveNowWeb.Task.Update,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HololiveNow.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HololiveNowWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
