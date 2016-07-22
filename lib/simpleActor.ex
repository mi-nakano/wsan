defmodule SimpleActor do
  use ContextEX
  use Actor


  deflf routine(msg), %{:categoryA => :layer1} do
    IO.puts "msg=#{msg} @layer1"
  end
  deflf routine(msg) do
    IO.puts "msg=#{msg} @default"
  end
end
