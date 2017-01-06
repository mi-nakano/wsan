defmodule SensorTest do
  use ExUnit.Case
  doctest Wsan.Sensor.Thermometer


  test "sensor test" do
    pid = Wsan.Sensor.Thermometer.spawn(self(), 1)
    receive do
      {:msg, sensor_pid, event} ->
        assert(1<= event.value and event.value <= 5)
        assert sensor_pid == pid
    end
  end
end
