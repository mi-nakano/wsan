defmodule WSANNodeTest do
  use ExUnit.Case
  doctest WSANNode

  def f(msg) do
    1
  end

  use WSANNode
  test "Node test" do
    pid = spawnNode(:f)
    sendMsg(pid, 0)
    receive do
      res -> assert res == 1
    end
    sendEnd(pid)
    receive do
      res -> assert res == {:ok}
    end
  end
end
