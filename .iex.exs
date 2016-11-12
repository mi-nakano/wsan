IO.puts "load this project's .iex.exs"

max_node = 10     # 実験で使用する最大ノード数
name_prefix = "node"  # ノード名
name_suffix = "@nakano-MBA" # ホスト名
# 使用するモジュール名
modules = [Elixir.Wsan.Actor,
  Elixir.ContextEX, Elixir.Wsan.Event,
  Elixir.Enumerable, Elixir.Wsan.Router,
  Elixir.Experiment, Elixir.Wsan.Sensor,
  Elixir.IEx.Info, Elixir.Wsan.SimpleActor,
  Elixir.Inspect, Elixir.Wsan,
  Elixir.LoggerFileBackend,
  Elixir.Sample,
]
# connect Nodes
for n <- 1 .. max_node do
  name = name_prefix <> Integer.to_string(n) <> name_suffix
  name |> String.to_atom |> Node.connect
end

# load modules

for module <- modules do
  nl(Node.list, module)
end
