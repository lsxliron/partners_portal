defmodule ICapital.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ICapitalWeb.Telemetry,
      ICapital.Repo,
      {DNSCluster, query: Application.get_env(:i_capital, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ICapital.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ICapital.Finch},
      # Start a worker by calling: ICapital.Worker.start_link(arg)
      # {ICapital.Worker, arg},
      # Start to serve requests, typically the last entry
      ICapitalWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ICapital.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ICapitalWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
