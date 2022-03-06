defmodule Hnefa.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Hnefa.Repo,
      # Start the Telemetry supervisor
      HnefaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Hnefa.PubSub},
      # Start the Endpoint (http/https)
      HnefaWeb.Endpoint,
      # Start a worker by calling: Hnefa.Worker.start_link(arg)
      # {Hnefa.Worker, arg}
      Hnefa.Game.start_link()
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hnefa.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HnefaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
