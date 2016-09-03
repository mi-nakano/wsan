defmodule ActorTest do
  use ExUnit.Case
  doctest Actor

  use ContextEX
  use Actor
  deflf routine(msg), %{:categoryA => :layer1} do
    msg * 10
  end
  deflf routine(msg), %{} do
    msg
  end

  test "Actor" do
    pid = spawnNode()
    assert callMsg(pid, 1) == 1
    activate_layer(pid, %{:categoryA => :layer1})
    Process.sleep 100
    assert callMsg(pid, 1) == 10
    assert callEnd(pid) == {:ok}
  end
end
