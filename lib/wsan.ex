defmodule Wsan do
  import Actor

  def start() do
    pid = SimpleActor.spawn()
    sensors = for n <- 1..3 do
      Sensor.start(pid, n)
    end

    Process.sleep 3000
    callEnd(pid)
  end

  def start(nodes) when is_list(nodes) do
    actors = for node <- nodes do
      actor = SimpleActor.spawn_on_node(node)
      for n <- 1..3 , do: Sensor.start(actor, n)
      actor
    end
    Process.sleep 3000
    for pid <- actors, do: callEnd pid
  end
end
