defmodule SensorTest do
  use ExUnit.Case
  doctest Sensor


  test "sensor test" do
    pid = Sensor.start(self, 0)
    receive do
      {:msg, sensor_pid, event} ->
        assert(1<= event.value and event.value <= 5)
        assert sensor_pid == pid
    end
  end
end
