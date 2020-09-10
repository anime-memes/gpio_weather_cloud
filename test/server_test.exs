defmodule GPIOWeatherCloudTest.Server do
  use ExUnit.Case

  alias GPIOWeatherCloud.{Server, WeatherAPI}

  @forecast %WeatherAPI.Forecast{temp: 10, conditions: "Clear", wind_speed: 1}

  test "init/1 sends itself a message to perform initial setup" do
    assert {:ok, %{}} == Server.init(%{})
    assert_receive :initial_setup
  end

  test "handle_cast/2 updates state with new forecast" do
    bypass = Bypass.open(port: 3000)
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"hourly": [{"temp": 10, "weather": [{"main": "Clear"}], "wind_speed": 1}]}>)
    end)

    assert {:noreply, @forecast} == Server.handle_cast(:update_forecast, %{})
  end

  test "handle_call/2 returns current forecast" do
    assert {:reply, @forecast, @forecast} == Server.handle_call(:get_forecast, self(), @forecast)
  end

  test "handle_info/2 saves new forecast to state as a part of setup" do
    bypass = Bypass.open(port: 3000)
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"hourly": [{"temp": 10, "weather": [{"main": "Clear"}], "wind_speed": 1}]}>)
    end)

    assert {:noreply, @forecast} == Server.handle_info(:initial_setup, %{})
  end
end
