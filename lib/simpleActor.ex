defmodule SimpleActor do
  use ContextEX
  use Actor
  require Logger


  deflf routine(msg), %{:categoryA => :layer1} do
    Logger.info "msg came @layer1!!!!!!!!!"
    Logger.info inspect(msg)
  end
  deflf routine(msg) do
    Logger.info "msg came @default"
    Logger.info inspect(msg)

    if (msg.value == 5), do: activate_layer(%{:categoryA => :layer1})
  end
end
