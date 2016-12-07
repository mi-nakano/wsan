defmodule Experiment do
  require Wsan.Router
  use ContextEX
  require Experiment.Analyzer

  @file_name "./log/experiment.log"
  @num_repeat 10
  @num_token 100
  @num_pairs 100
  @num_process 100

  defp do_experimet(num, output_file, measure_func, args \\ []) do
    File.write(output_file, "")
    for _ <- 1..num do
      result = apply(measure_func, args)
      File.write(output_file, Integer.to_string(result), [:append])
      File.write(output_file, "\n", [:append])
    end
  end

  def experiment1() do
    IO.puts "========== experiment1 =========="
    IO.puts "@num_repeat = #{@num_repeat}"
    IO.puts "@num_token = #{@num_token}"
    IO.puts "-----experiment1_1-----"
    experiment1_1()
    IO.puts "-----experiment1_2-----"
    experiment1_2()
  end

  def experiment2() do
    IO.puts "========== experiment2 =========="
    IO.puts "@num_repeat = #{@num_repeat}"
    IO.puts "@num_token = #{@num_token}"
    IO.puts "@num_pairs = #{@num_pairs}"
    IO.puts "-----experiment2_1-----"
    experiment2_1()
    IO.puts "-----experiment2_2-----"
    experiment2_2()
  end

  def experiment_activation() do
    IO.puts "========== experiment_activation =========="
    IO.puts "@num_repeat = #{@num_repeat}"
    IO.puts "@num_process = #{@num_process}"
    IO.puts "-----experiment-----"
    do_experimet(@num_repeat, @file_name, &Experiment.Activation.measure_activation/1, [@num_process])
    Experiment.Analyzer.analyze(@filename)
  end

  defp experiment1_1() do
    do_experimet(@num_repeat, @file_name, &Experiment.Pingpong.measure_pingpong/1, [@num_token])
    Experiment.Analyzer.analyze(@file_name)
  end

  defp experiment1_2() do
    do_experimet(@num_repeat, @file_name, &Experiment.Pingpong.measure_pingpong_lf/1, [@num_token])
    Experiment.Analyzer.analyze(@file_name)
  end

  defp experiment2_1() do
    do_experimet(@num_repeat, @file_name, &Experiment.Pingpong.measure_pingpong_multiple/2, [@num_token, @num_pairs])
    Experiment.Analyzer.analyze(@file_name)
  end

  defp experiment2_2() do
    do_experimet(@num_repeat, @file_name, &Experiment.Pingpong.measure_pingpong_multiple_lf/2, [@num_token, @num_pairs])
    Experiment.Analyzer.analyze(@file_name)
  end
end
