defmodule Organization.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      OrganizationWeb.Telemetry,
      # Start the Ecto repository
      Organization.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Organization.PubSub},
      # Start Finch
      {Finch, name: Organization.Finch},
      # Start the Endpoint (http/https)
      OrganizationWeb.Endpoint
      # Start a worker by calling: Organization.Worker.start_link(arg)
      # {Organization.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Organization.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OrganizationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
