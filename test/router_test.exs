defmodule RouterTest do
  use ExUnit.Case
  doctest Wsan.Router



  test "router" do
    table = [{?a..?c, :"node1"},
             {?d..?z, :"node2"}]
    Application.put_env(:wsan, :routing_table, table)
    assert Wsan.Router.lookup_table("aaa") == :"node1"
    assert Wsan.Router.lookup_table("ddd") == :"node2"
  end
end
