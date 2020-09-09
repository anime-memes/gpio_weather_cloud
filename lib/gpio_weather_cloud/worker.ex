defmodule GPIOWeatherCloud.Worker do
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
  def handle_cast(:update_forecast, _) do
    {:noreply, WeatherAPI.get_new_forecast()}
  end

  @impl GenServer
  def handle_call(:get_forecast, _, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_info(:initial_setup, _) do
    {:ok, new_forecast} = WeatherAPI.get_new_forecast()
    CloudUpdater.update_cloud(new_forecast)
    {:noreply, new_forecast}
  end

  @impl GenServer
  def terminate(_, _) do
    CloudUpdater.clear_pins()
  end
end
