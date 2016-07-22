defmodule SensorTest do
  use ExUnit.Case
  doctest Sensor


  test "sensor test" do
    pid = Sensor.start(self)
    receive do
      {:event, event} -> assert(1<= event.value and event.value <= 5)
    end
  end
end
