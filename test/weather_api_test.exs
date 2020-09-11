defmodule GPIOWeatherCloudTest.WeatherAPI do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 3000)
    {:ok, bypass: bypass}
  end

  defp correct_response do
    """
    {
      "hourly": [{
        "temp": 10,
        "weather": [{"main": "Clear"}],
        "wind_speed": 1,
        "clouds": 75
      }],
      "current": {
        "temp": 100,
        "weather": [{"main": "Clouds"}],
        "wind_speed": 10
      }
    }
    """
  end

  describe "get_new_forecast/0" do
    test "returns the forecast", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, correct_response())
      end)

      assert {:ok,
              %GPIOWeatherCloud.WeatherAPI.Forecast{temp: 10, conditions: "Clear", wind_speed: 1}} ==
               GPIOWeatherCloud.WeatherAPI.get_new_forecast()
    end

    test "returns error tuple when invalid response encountered", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, "Invalid response")
      end)

      assert {:error, :invalid_response} == GPIOWeatherCloud.WeatherAPI.get_new_forecast()
    end

    test "returns error tuple when bad status encountered", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 404, "")
      end)

      assert {:error, :invalid_response} == GPIOWeatherCloud.WeatherAPI.get_new_forecast()
    end

    test "returns error tuple when unexpected things happen", %{bypass: bypass} do
      Bypass.down(bypass)

      assert {:error, :request_error} == GPIOWeatherCloud.WeatherAPI.get_new_forecast()
    end
  end
end
