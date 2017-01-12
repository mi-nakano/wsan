defmodule Wsan do

  def start() do
    actors = for n <- 1..4 do
      # actor node
      actor_pid = Router.route(n, Wsan.Actor, :start, [n, :actor])

      # sensor nodes
      Router.route(n, Wsan.Sensor.Thermometer, :start, [actor_pid, 1])
      Router.route(n, Wsan.Sensor.SmokeSensor, :start, [actor_pid, 2])
    end
  end
end
