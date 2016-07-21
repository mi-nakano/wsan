defmodule SensorTest do
  use ExUnit.Case
  doctest Sensor


  test "sensor test" do
    pid = Sensor.start(self)
    receive do
      {:data, pid, data} -> assert(1<= data and data <= 5)
    end
  end
end
