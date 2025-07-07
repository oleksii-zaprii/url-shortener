defmodule UrlShortenerApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UrlShortenerApiWeb.Telemetry,
      UrlShortenerApi.Repo,
      {DNSCluster, query: Application.get_env(:url_shortener_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UrlShortenerApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: UrlShortenerApi.Finch},
      # Start a worker by calling: UrlShortenerApi.Worker.start_link(arg)
      # {UrlShortenerApi.Worker, arg},
      # Start to serve requests, typically the last entry
      UrlShortenerApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UrlShortenerApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UrlShortenerApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
