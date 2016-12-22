defmodule Experiment do
  require Wsan.Router
  use ContextEX
  require Experiment.Analyzer

  @log_dir "./log/"
  @file_name "experiment.log"
  @num_repeat 10
  @num_token 100
  @num_pairs 100
  @num_process 100

  defp do_experimet(num, output_file, measure_func, args \\ []) do
    unless (File.exists? @log_dir), do: File.mkdir @log_dir
    file_path = @log_dir <> output_file
    File.write(file_path, "")
    for _ <- 1..num do
      result = apply(measure_func, args)
      File.write(file_path, Integer.to_string(result), [:append])
      File.write(file_path, "\n", [:append])
    end
    Experiment.Analyzer.analyze(file_path)
  end

  def experiment1() do
    IO.puts "========== experiment1 =========="
    IO.puts "num_repeat = #{@num_repeat}"
    IO.puts "num_token = #{@num_token}"
    IO.puts "----- pingpong -----"
    do_experimet(@num_repeat, @file_name, &Experiment.Pingpong.measure_pingpong/1, [@num_token])

    IO.puts "----- pingpong (layered) -----"
    do_experimet(@num_repeat, @file_name, &Experiment.Pingpong.measure_pingpong_lf/1, [@num_token])
  end

  def experiment2(num_pairs \\ @num_pairs) do
    IO.puts "========== experiment2 =========="
    IO.puts "num_repeat = #{@num_repeat}"
    IO.puts "num_token = #{@num_token}"
    IO.puts "num_pairs = #{num_pairs}"
    IO.puts "----- pingpong n pair-----"
    do_experimet(@num_repeat, @file_name, &Experiment.Pingpong.measure_pingpong_multiple/2, [@num_token, num_pairs])

    IO.puts "----- pingpong n pair (layered) -----"
    do_experimet(@num_repeat, @file_name, &Experiment.Pingpong.measure_pingpong_multiple_lf/2, [@num_token, num_pairs])
  end

  def experiment_activation(num_process \\ @num_process) do
    IO.puts "========== experiment_activation =========="
    IO.puts "num_repeat = #{@num_repeat}"
    IO.puts "num_process = #{num_process}"
    IO.puts "----- comparison experiment -----"
    do_experimet(@num_repeat, @file_name, &Experiment.Activation.measure_activation_comparison/1, [num_process])
    IO.puts "----- group activation -----"
    do_experimet(@num_repeat, @file_name, &Experiment.Activation.measure_activation/1, [num_process])
  end
end
