defmodule GPIOWeatherCloud.CloudUpdater do
  alias GPIOWeatherCloud.WeatherAPI.Forecast

  @temp_pins [13, 19, 16]
  @wind_pins [18, 15, 24, 26]
  @condition_pins %{"Clear" => 2, "Clouds" => 3, "Rain" => 4, "Snow" => 8}
  @cloud_pins [14, 17, 10, 12, 21]

  def update_cloud(%Forecast{
        temp: temp,
        clouds: clouds,
        conditions: conditions,
        wind_speed: wind_speed
      }) do
    clear_pins()
    set_temp_pins(temp)
    set_wind_pins(wind_speed)
    set_conditions_pins(conditions)
    set_cloud_pins(clouds)
  end

  def clear_pins do
    [@temp_pins, @wind_pins, Map.values(@condition_pins), @cloud_pins]
    |> List.flatten()
    |> Enum.each(&set_pin(&1, 0))
  end

  defp set_temp_pins(temp) do
    @temp_pins
    |> Enum.take(min(abs(temp) / 10, 3))
    |> Enum.each(&set_pin(&1, 1))
  end

  defp set_wind_pins(wind_speed) do
    @wind_pins
    |> Enum.take(min(wind_speed / 8, 4))
    |> Enum.each(&set_pin(&1, 1))
  end

  defp set_conditions_pins(conditions) do
    case @condition_pins[conditions] do
      nil -> nil
      pin -> set_pin(pin, 1)
    end
  end

  defp set_cloud_pins(clouds) do
    @cloud_pins
    |> Enum.take(min(clouds / 20, 5))
    |> Enum.each(&set_pin(&1, 1))
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
