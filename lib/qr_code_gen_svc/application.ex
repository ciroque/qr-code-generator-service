defmodule QrCodeGenSvc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      QrCodeGenSvcWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:qr_code_gen_svc, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: QrCodeGenSvc.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: QrCodeGenSvc.Finch},
      # Start a worker by calling: QrCodeGenSvc.Worker.start_link(arg)
      # {QrCodeGenSvc.Worker, arg},
      # Start to serve requests, typically the last entry
      QrCodeGenSvcWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: QrCodeGenSvc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    QrCodeGenSvcWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
