defmodule GPIOWeatherCloud.WeatherAPI do
  defmodule Forecast do
    defstruct temp: nil, conditions: "", wind_speed: nil

    @type t :: %__MODULE__{
            temp: number(),
            conditions: binary(),
            wind_speed: number()
          }
  end

  alias GPIOWeatherCloud.Config

  def get_new_forecast do
    build_url()
    |> HTTPoison.get()
    |> process_response()
  end

  defp build_url do
    "#{Config.api_url()}?lat=#{Config.latitude()}&lon=#{Config.longitude()}&exclude=current,minutely,daily&appid=#{
      Config.api_token()
    }&units=metric"
  end

  defp process_response({:ok, %{status_code: 200, body: body}}) do
    case Jason.decode(body) do
      {:ok, new_forecast} ->
        new_forecast
        |> Map.get("hourly")
        |> hd()
        |> build_forecast()

      _ ->
        {:error, :invalid_response}
    end
  end

  defp process_response({:ok, _}), do: {:error, :invalid_response}

  defp process_response(_), do: {:error, :request_error}

  defp build_forecast(%{
         "temp" => real_temp,
         "weather" => next_weather,
         "wind_speed" => wind
       }) do
    {:ok,
     %Forecast{
       temp: real_temp,
       conditions: next_weather |> hd() |> Map.get("main"),
       wind_speed: wind
     }}
  end
end
