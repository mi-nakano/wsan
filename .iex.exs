max_node = 10     # 実験で使用する最大ノード数
name_prefix = "node"  # ノード名
name_suffix = "@nakano-MBA" # ホスト名

for n <- 1 .. max_node do
  name = name_prefix <> Integer.to_string(n) <> name_suffix
  name |> String.to_atom |> Node.connect
end

IO.puts "load this project's .iex.exs"
