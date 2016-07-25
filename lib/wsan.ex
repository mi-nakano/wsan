defmodule Wsan do
  import Actor

  def start() do
    pid = SimpleActor.spawnNode()
    sensors = for n <- 1..3 do
      Sensor.start(pid, n)
    end

    Process.sleep 3000
    callEnd(pid)
  end
end
