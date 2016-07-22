defmodule Wsan do
  import Actor

  def start() do
    pid = SimpleActor.spawnNode()
    callMsg(pid, 1)
    castActivate(pid, %{:categoryA => :layer1})
    callMsg(pid, 1)
    callEnd(pid)
  end
end
