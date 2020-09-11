defmodule GPIOWeatherCloud.Config do
  def api_url, do: Application.get_env(:gpio_weather_cloud, :api_url)
  def api_token, do: Application.get_env(:gpio_weather_cloud, :api_token)
  def latitude, do: Application.get_env(:gpio_weather_cloud, :lat)
  def longitude, do: Application.get_env(:gpio_weather_cloud, :lon)
  def temp_pins, do: Application.get_env(:gpio_weather_cloud, :temp_pins)

  def condition_pins do
    Enum.zip(
      Application.get_env(:gpio_weather_cloud, :weather_conditions),
      Application.get_env(:gpio_weather_cloud, :condition_pins)
    )
    |> Enum.into(%{})
  end

  def wind_pins, do: Application.get_env(:gpio_weather_cloud, :wind_pins)
end
