defmodule RouterTest do
  use ExUnit.Case
  doctest Router

  test "router" do
    table = [{1, :"node1"},
             {2, :"node2"}]
    Application.put_env(:wsan, :routing_table, table)
    assert Router.lookup_table(1) == :"node1"
    assert Router.lookup_table(2) == :"node2"
  end
end
