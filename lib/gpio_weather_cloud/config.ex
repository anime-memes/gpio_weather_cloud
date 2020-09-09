defmodule GPIOWeatherCloud.Config do
  def api_url, do: Application.get_env(:gpio_weather_cloud, :api_url)
  def api_token, do: Application.get_env(:gpio_weather_cloud, :api_token)
  def latitude, do: Application.get_env(:gpio_weather_cloud, :lat)
  def longitude, do: Application.get_env(:gpio_weather_cloud, :lon)
end
