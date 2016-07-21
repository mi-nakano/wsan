defmodule SimpleActor do
  use ContextEX
  use Actor


  deflf routine(msg), %{:categoryA => :layer1} do
    1
  end
  deflf routine(msg) do
    0
  end
end
