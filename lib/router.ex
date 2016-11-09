defmodule Wsan.Router do
  def route(number, mod, fun, args) when is_integer(number) do
    # Try to find an entry in the table or raise
    node_name = lookup_table(number)

    # If the entry node is the current node
    if node_name == node() do
      apply(mod, fun, args)
    else
      node_name
        |> Node.spawn(mod, fun, args)
    end
  end

  # return node_name
  def lookup_table(number) when is_integer(number) do
    entry =
      Enum.find(table, fn {key, _node} ->
        number == key
      end) || no_entry_error(number)
    elem(entry, 1)
  end


  defp no_entry_error(number) do
    raise "could not find entry for #{inspect number} in table #{inspect table}"
  end

  def table() do
    Application.fetch_env!(:wsan, :routing_table)
  end
end
