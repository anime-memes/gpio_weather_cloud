defmodule GPIOWeatherCloud.MixProject do
  use Mix.Project

  def project do
    [
      app: :gpio_weather_cloud,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {GPIOWeatherCloud.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.7.0"},
      {:circuits_gpio, "~> 0.4.5"},
      {:jason, "~> 1.2.2"},
      {:excoveralls, "~> 0.13.1", only: :test},
      {:dialyxir, "~> 1.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.4.0", only: :dev, runtime: false},
      {:bypass, "~> 2.0.0", only: :test}
    ]
  end
end
