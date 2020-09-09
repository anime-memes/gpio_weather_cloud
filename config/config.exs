import Config

config :gpio_weather_cloud,
  api_url: "https://api.openweathermap.org/data/2.5/onecall"

import_config "#{Mix.env()}.exs"
