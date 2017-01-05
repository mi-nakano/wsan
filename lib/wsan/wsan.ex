defmodule Wsan do
  import Wsan.Actor

  def start() do
    actors = for n <- 1..2 do
      actor = Router.route(1, Wsan.SimpleActor, :start, [])
      for m <- 1..2, do: Router.route(2, Wsan.Sensor, :start, [actor, m])
      actor
    end

    Process.sleep 3000
    for actor <- actors, do: call_end(actor)
  end
end
