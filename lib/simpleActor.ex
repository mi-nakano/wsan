defmodule SimpleActor do
  use ContextEX
  use Actor


  deflf routine(msg), %{:categoryA => :layer1} do
    IO.puts "msg came @layer1!!!!!!!!!"
    IO.inspect msg
  end
  deflf routine(msg) do
    IO.puts "msg came @default"
    IO.inspect msg

    value = Map.get(msg, :value)
    if (value == 5), do: activateLayer(%{:categoryA => :layer1})
  end
end
