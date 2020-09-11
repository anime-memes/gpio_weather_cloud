defmodule GPIOWeatherCloud.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      GPIOWeatherCloud.Server,
      %{
        id: "updater",
        start:
          {SchedEx, :run_every, [GPIOWeatherCloud.Server, :update_forecast, [], "*/30 * * * *"]}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GPIOWeatherCloud.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
