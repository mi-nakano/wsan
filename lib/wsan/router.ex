defmodule Wsan.Router do
  def route(bucket, mod, fun, args) do
    # Try to find an entry in the table or raise
    node_name = lookup_table(bucket)

    # If the entry node is the current node
    if node_name == node() do
      apply(mod, fun, args)
    else
      node_name
        |> Node.spawn(mod, fun, args)
    end
  end

  # return node_name
  def lookup_table(bucket) do
    first = :binary.first(bucket)
    entry =
      Enum.find(table, fn {enum, _node} ->
        first in enum
      end) || no_entry_error(bucket)
    elem(entry, 1)
  end

  defp no_entry_error(bucket) do
    raise "could not find entry for #{inspect bucket} in table #{inspect table}"
  end

  def table() do
    Application.fetch_env!(:wsan, :routing_table)
  end
end
