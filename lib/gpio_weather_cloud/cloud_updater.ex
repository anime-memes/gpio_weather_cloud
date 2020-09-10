defmodule GPIOWeatherCloud.CloudUpdater do
  require Logger
  alias GPIOWeatherCloud.WeatherAPI.Forecast
  alias GPIOWeatherCloud.Config

  def update_cloud(%Forecast{
        temp: temp,
        conditions: conditions,
        wind_speed: wind_speed
      }) do
    clear_pins()
    set_temp_pins(temp)
    set_wind_pins(wind_speed)
    set_conditions_pins(conditions)
  end

  def clear_pins do
    Logger.info("Clearing pins...")

    [Config.temp_pins(), Config.wind_pins(), Map.values(Config.condition_pins())]
    |> List.flatten()
    |> Enum.each(&set_pin(&1, 0))
  end

  defp set_temp_pins(temp) do
    Logger.info("Setting temp pins...")

    Config.temp_pins()
    |> Enum.take(min(floor(abs(temp) / 10), 3))
    |> Enum.each(&set_pin(&1, 1))
  end

  defp set_wind_pins(wind_speed) do
    Logger.info("Setting wind pins...")

    Config.wind_pins()
    |> Enum.take(min(floor(wind_speed / 8) + 1, 4))
    |> Enum.each(&set_pin(&1, 1))
  end

  defp set_conditions_pins(conditions) do
    Logger.info("Setting conditions pins...")

    case Map.get(Config.condition_pins(), conditions) do
      nil -> nil
      pin -> set_pin(pin, 1)
    end
  end

  defp set_pin(pin, 0) do
    {:ok, gpio} = Circuits.GPIO.open(pin, :output)
    Circuits.GPIO.write(gpio, 0)
    Circuits.GPIO.close(gpio)
  end

  defp set_pin(pin, 1) do
    {:ok, gpio} = Circuits.GPIO.open(pin, :output)
    Circuits.GPIO.write(gpio, 1)
  end
end
