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

  test "Node test" do
    pid = spawnNode()
    assert callMsg(pid, [1]) == 1
    castActivate(pid, %{:categoryA => :layer1})
    assert callMsg(pid, [1]) == 10
    assert callEnd(pid) == {:ok}
  end
end