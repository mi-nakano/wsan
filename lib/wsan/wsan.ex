defmodule Wsan do
  import Wsan.Actor

  def start() do
    actors = for n <- 1..4 ,do: Router.route(n, Wsan.SimpleActor, :start, [])

    Process.sleep 3000
    for actor <- actors, do: call_end(actor)
  end
end
