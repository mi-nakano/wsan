defmodule Experiment do
  require Router
  use ContextEX
  require Experiment.Analyzer

  @log_dir "./log/"
  @num_repeat 10
  @num_token 100
  @num_pairs 100
  @num_process 100

  defp do_experiment(num, output_file, measure_func, args) do
    unless (File.exists? @log_dir), do: File.mkdir @log_dir
    file_path = @log_dir <> output_file
    for _ <- 1..num do
      result = apply(measure_func, args)
      File.write(file_path, Integer.to_string(result), [:append])
      File.write(file_path, "\n", [:append])
      IO.write "."
      remove_registered_process
    end
    IO.puts "end"
    Experiment.Analyzer.analyze(file_path)
  end

  def experiment1(num_token \\ @num_token) do
    IO.puts "========== experiment1 =========="
    IO.puts "num_repeat = #{@num_repeat}"
    IO.puts "num_token = #{num_token}"
    IO.puts "----- pingpong -----"
    do_experiment(@num_repeat, "pingpong-#{num_token}token.log", &Experiment.Pingpong.measure_pingpong/1, [num_token])

    IO.puts "----- pingpong (layered) -----"
    do_experiment(@num_repeat, "pingpong-#{num_token}token_layered.log", &Experiment.Pingpong.measure_pingpong_lf/1, [num_token])
  end

  def experiment2(num_pairs \\ @num_pairs) do
    IO.puts "========== experiment2 =========="
    IO.puts "num_repeat = #{@num_repeat}"
    IO.puts "num_token = #{@num_token}"
    IO.puts "num_pairs = #{num_pairs}"
    IO.puts "----- pingpong #{num_pairs} pair-----"
    do_experiment(@num_repeat, "pingpong-#{@num_token}token-#{num_pairs}pair.log", &Experiment.Pingpong.measure_pingpong_multiple/2, [@num_token, num_pairs])

    IO.puts "----- pingpong #{num_pairs} pair (layered) -----"
    do_experiment(@num_repeat, "pingpong-#{@num_token}token-#{num_pairs}pair_layered.log", &Experiment.Pingpong.measure_pingpong_multiple_lf/2, [@num_token, num_pairs])
  end

  def experiment_activation(num_node, num_process \\ @num_process) do
    IO.puts "========== experiment_activation =========="
    IO.puts "num_repeat = #{@num_repeat}"
    IO.puts "num_node = #{num_node}"
    IO.puts "num_process = #{num_process}"
    IO.puts "----- comparison experiment -----"
    do_experiment(@num_repeat, "activation-#{num_node}node-#{num_process}process_comparison.log", &Experiment.Activation.measure_activation_comparison/2, [num_node, num_process])
    IO.puts "----- group activation -----"
    do_experiment(@num_repeat, "activation-#{num_node}node-#{num_process}.log", &Experiment.Activation.measure_activation/2, [num_node, num_process])
  end
end
