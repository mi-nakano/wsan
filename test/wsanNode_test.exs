defmodule WSANNodeTest do
  use ExUnit.Case
  doctest WSANNode

  use ContextEX
  use WSANNode
  deflf routine(msg), %{:categoryA => :layer1} do
    10
  end
  deflf routine(msg), %{} do
    1
  end

  test "Node test" do
    pid = spawnNode()
    sendMsg(pid, 0)
    receive do
      res -> assert res == 1
    end
    activateNode(pid, %{:categoryA => :layer1})
    sendMsg(pid, 0)
    receive do
      res -> assert res == 10
    end
    sendEnd(pid)
    receive do
      res -> assert res == {:ok}
    end
  end
end
