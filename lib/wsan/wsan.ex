defmodule Wsan do

  def start() do
    actors = for n <- 1..4 do
      # actor node
      actor_pid = Router.route(n, Wsan.Actor, :start, [n, :actor])

      # sensor nodes
      Wsan.Sensor.Thermometer.spawn(actor_pid, 1)
      Wsan.Sensor.SmokeSensor.spawn(actor_pid, 2)
    end
  end
end
