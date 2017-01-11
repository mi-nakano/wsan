defmodule Experiment do
  require Router
  use ContextEX
  require Experiment.Analyzer

  @log_dir "./log/"
  @num_repeat 10
  @num_token 10
  @num_pairs 100
  @num_process 100
  @time_out 3_00000

  defp do_experiment(num, output_file, measure_func, args) do
    unless (File.exists? @log_dir), do: File.mkdir @log_dir
    file_path = @log_dir <> output_file
    for _ <- 1..num, do: experiment_once(file_path, measure_func, args)
    IO.puts ""
    Experiment.Analyzer.analyze(file_path)
  end

  defp experiment_once(file_path, measure_func, args) do
    remove_registered_process()
    self_pid = self()
    pid = spawn(fn ->
      result = apply(measure_func, args)
      send self_pid, {:ok, result}
    end)
    receive do
      {:ok, result} ->
        File.write(file_path, Integer.to_string(result), [:append])
        File.write(file_path, "\n", [:append])
        IO.write "."
    after
      @time_out ->
        IO.write "F"
        Process.exit(pid, :kill)
        experiment_once(file_path, measure_func, args)
    end
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
