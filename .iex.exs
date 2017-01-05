IO.puts "load this project's .iex.exs"

# 使用するモジュール名
modules = [
  Elixir.ContextEX,
  Elixir.LoggerFileBackend,
  Elixir.Router,
  Elixir.Experiment,
  Elixir.Experiment.Pingpong,
  Elixir.Experiment.Activation,
  Elixir.Experiment.Analyzer,
  Elixir.Wsan,
  Elixir.Wsan.Actor,
  Elixir.Wsan.Thermometer,
  Elixir.Wsan.SmokeSensor,
  Elixir.Wsan.Event,
]

# connect Nodes
# iex -S mixで始めた場合はconfigを読み込める
case Application.fetch_env(:wsan, :routing_table) do
  {:ok, table} ->
    IO.puts "Success to fetch_env"
    for {_, node} <- table do
      Node.connect(node)
    end
    # load module
    for module <- modules do
      nl(Node.list, module)
    end
  _ ->
    IO.puts "failed to fetch_env"
end
