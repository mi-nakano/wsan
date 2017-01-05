defmodule Wsan do

  def start() do
    actors = for n <- 1..4 ,do: Router.route(n, Wsan.Actor, :start, [n])

    Process.sleep 3000
    for actor <- actors, do: Wsan.Actor.call_end(actor)
  end
end
