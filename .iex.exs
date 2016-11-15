IO.puts "load this project's .iex.exs"

max_node = 10     # 実験で使用する最大ノード数
name_prefix = "node"  # ノード名
name_suffix = "@nakano-MBA" # ホスト名
# 使用するモジュール名
modules = [Elixir.Wsan.Actor,
  Elixir.ContextEX,
  Elixir.LoggerFileBackend,
  Elixir.Sample,
  Elixir.Experiment,
  Elixir.Experiment.Pingpong,
  Elixir.Experiment.Analyzer,
  Elixir.Wsan,
  Elixir.Wsan.Router,
  Elixir.Wsan.Sensor,
  Elixir.Wsan.Event,
  Elixir.Wsan.SimpleActor,
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
