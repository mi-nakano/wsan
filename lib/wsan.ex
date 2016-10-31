defmodule Wsan do
  import Actor

  def start() do
    actors = for n <- 1..2 do
      actor = Wsan.Router.route(1, SimpleActor, :spawn, [])
      for m <- 1..2, do: Wsan.Router.route(2, Sensor, :start, [actor, m])
      actor
    end

    Process.sleep 3000
    for actor <- actors, do: callEnd(actor)
  end
end
