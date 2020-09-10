import Config

config :gpio_weather_cloud,
  api_url: "https://api.openweathermap.org/data/2.5/onecall",
  temp_pins: [13, 19, 16],
  wind_pins: [15, 18, 24, 26],
  condition_pins: [14, 17, 10, 12, 21],
  weather_conditions: ["Clear", "Drizzle", "Clouds", "Rain", "Snow"]

import_config "#{Mix.env()}.exs"
