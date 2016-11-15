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

  def experiment1(filepath \\ "./test.csv") do
    IO.puts "-----experiment1_1-----"
    experiment1_1(filepath)
    IO.puts "-----experiment1_2-----"
    experiment1_2(filepath)
  end

  defp experiment1_1(filepath) do
    do_experimet(@num_repeat, filepath, &measure_pingpong/1, [@num_token])
    Experiment.Analyzer.analyze(filepath)
  end

  defp experiment1_2(filepath) do
    do_experimet(@num_repeat, filepath, &measure_pingpong_lf/1, [@num_token])
    Experiment.Analyzer.analyze(filepath)
  end


  # funcを実行し、それにかかった時間を出力
  def measure(func, args \\ []) do
    prev = System.os_time()

    # do something
    apply(func, args)

    diff = System.os_time() - prev
    # IO.write "Time: "
    # IO.inspect diff
    diff
  end

  def measure_pingpong(num_token) do
    # prepare
    n1 = Wsan.Router.route(1, Experiment, :pingpong, [self])
    n2 = Wsan.Router.route(2, Experiment, :pingpong, [self])

    # do something
    measure(fn ->
      send n1, {n2, num_token}
      receive do
        :ok -> :ok
      end
    end)
  end

  # n=0 になるまで減算、0になったらparentに送信
  def pingpong(parent) do
    receive do
      {_, 0} ->
        send parent, :ok
      {pid, n} ->
        send pid, {self, n-1}
        pingpong(parent)
    end
  end

  def measure_pingpong_lf(num_token) do
    # prepare
    n1 = Wsan.Router.route(1, Experiment, :pingpong_lf, [self])
    n2 = Wsan.Router.route(2, Experiment, :pingpong_lf, [self])

    # do something
    measure(fn ->
      send n1, {n2, num_token}
      receive do
        :ok -> :ok
      end
    end)
  end

  def pingpong_lf(parent) do
    init_context()
    loop(parent)
  end
  defp loop(parent) do
    receive do
      {_, 0} ->
        send parent, :ok
      {pid, n} ->
        pingpong_lf_body(pid, n)
        loop(parent)
    end
  end

  deflf pingpong_lf_body(pid, n) do
    send pid, {self, n-1}
  end
end
