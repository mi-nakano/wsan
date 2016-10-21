defmodule Wsan do
  import Actor

  def start() do
    actors = for n <- 1..3 do
      actor = Wsan.Router.route(1, SimpleActor, :spawn, [])
      for n <- 1..3, do: Wsan.Router.route(2, Sensor, :start, [actor, n])
      actor
    end

    Process.sleep 3000
    for actor <- actors, do: callEnd(actor)
  end
end
