defmodule Experiment do
  require Wsan.Router
  use ContextEX
  require Experiment.Analyzer

  @num_repeat 100
  @num_token 100

  defp do_experimet(num, output_file, measure_func, args \\ []) do
    File.write(output_file, "")
    for _ <- 1..num do
      time = apply(measure_func, args)
      File.write(output_file, Integer.to_string(time), [:append])
      File.write(output_file, "\n", [:append])
    end
  end

  def experiment1(filepath \\ "./log/test.log") do
    IO.puts "-----experiment1_1-----"
    experiment1_1(filepath)
    IO.puts "-----experiment1_2-----"
    experiment1_2(filepath)
  end

  defp experiment1_1(filepath) do
    do_experimet(@num_repeat, filepath, &Experiment.Pingpong.measure_pingpong/1, [@num_token])
    Experiment.Analyzer.analyze(filepath)
  end

  defp experiment1_2(filepath) do
    do_experimet(@num_repeat, filepath, &Experiment.Pingpong.measure_pingpong_lf/1, [@num_token])
    Experiment.Analyzer.analyze(filepath)
  end
end
