defmodule GPIOWeatherCloud.Server do
  require Logger
  use GenServer

  alias GPIOWeatherCloud.{CloudUpdater, WeatherAPI}

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl GenServer
  def init(state) do
    Process.send_after(self(), :initial_setup, 0)
    {:ok, state}
  end

  def update_forecast do
    GenServer.cast(__MODULE__, :update_forecast)
  end

  def get_forecast do
    GenServer.call(__MODULE__, :get_forecast)
  end

  @impl GenServer
  def handle_cast(:update_forecast, old_forecast) do
    Logger.info("Updating the forecast...")

    case WeatherAPI.get_new_forecast() do
      {:ok, forecast} ->
        {:noreply, forecast}

      {:error, _} ->
        {:noreply, old_forecast}
    end
  end

  @impl GenServer
  def handle_call(:get_forecast, _, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_info(:initial_setup, _) do
    Logger.info("Performing setup...")

    case WeatherAPI.get_new_forecast() do
      {:ok, forecast} ->
        CloudUpdater.update_cloud(forecast)
        {:noreply, forecast}

      {:error, _} ->
        {:noreply, %{}}
    end
  end

  @impl GenServer
  def terminate(_, _) do
    Logger.info("Terminating...")
    CloudUpdater.clear_pins()
  end
end
