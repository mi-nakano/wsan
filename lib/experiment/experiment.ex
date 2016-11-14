defmodule Experiment do
  require Wsan.Router
  use ContextEX
  require Experiment.Analyzer

  @num_repeat 100
  @num_token 100

  def experiment1(filepath \\ "./test.csv") do
    # 上書き
    File.write(filepath, "")
    for _ <- 1..@num_repeat do
      time = start_pingpong()
      File.write(filepath, Integer.to_string(time), [:append])
      File.write(filepath, "\n", [:append])
    end
    Experiment.Analyzer.analyze(filepath)
  end

  def experiment2(filepath \\ "./test.csv") do
    # 上書き
    File.write(filepath, "")
    for _ <- 1..@num_repeat do
      time = start_pingpong_lf()
      File.write(filepath, Integer.to_string(time), [:append])
      File.write(filepath, "\n", [:append])
    end
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

  def start_pingpong() do
    # prepare
    n1 = Wsan.Router.route(1, Experiment, :pingpong, [self])
    n2 = Wsan.Router.route(2, Experiment, :pingpong, [self])

    # do something
    measure(fn ->
      send n1, {n2, @num_token}
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

  def start_pingpong_lf() do
    # prepare
    n1 = Wsan.Router.route(1, Experiment, :pingpong_lf, [self])
    n2 = Wsan.Router.route(2, Experiment, :pingpong_lf, [self])

    # do something
    measure(fn ->
      send n1, {n2, @num_token}
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
