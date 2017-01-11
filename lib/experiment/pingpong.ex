defmodule Experiment.Pingpong do
  require Router
  import Experiment.Analyzer
  use ContextEX


  defp routine(num_token, func_atom) do
    # prepare
    n1 = Router.route(2, __MODULE__, func_atom, [self])
    n2 = Router.route(3, __MODULE__, func_atom, [self])

    # do something, measure time
    measure(fn ->
      send n1, {n2, num_token}
      receive do
        :ok -> :ok
      end
    end)
  end

  defp routine_multiple(num_token, num_pairs, func_atom) do
    # prepare
    pairs = for _ <- 1..num_pairs do
      n1 = Router.route(2, __MODULE__, func_atom, [self])
      n2 = Router.route(3, __MODULE__, func_atom, [self])
      {n1, n2}
    end

    # 準備ができるまでまつ
    for _ <- 1..num_pairs do
      receive do
        :ready -> :ok
      end
      receive do
        :ready -> :ok
      end
    end

    # do something, measure time
    measure(fn ->
      for pair <- pairs do
        send elem(pair,0), {elem(pair, 1), num_token}
      end
      for _ <- 1..num_pairs do
        receive do
          :ok -> :ok
        end
      end
    end)
  end

  def measure_pingpong(num_token) do
    routine(num_token, :pingpong)
  end
  def measure_pingpong_lf(num_token) do
    routine(num_token, :pingpong_lf)
  end

  def measure_pingpong_multiple(num_token, num_pairs) do
    routine_multiple(num_token, num_pairs, :pingpong)
  end
  def measure_pingpong_multiple_lf(num_token, num_pairs) do
    routine_multiple(num_token, num_pairs, :pingpong_lf)
  end


  # n=0 になるまで減算、0になったらparentに送信
  def pingpong(parent) do
    send parent, :ready
    receive do
      :end ->
        :end
      {pid, 0} ->
        send parent, :ok
        send pid, :end
      {pid, n} ->
        send pid, {self, n-1}
        pingpong(parent)
    end
  end

  def pingpong_lf(parent) do
    Process.sleep 10
    init_context()
    send parent, :ready
    loop(parent)
  end

  defp loop(parent) do
    receive do
      :end ->
        :end
      {pid, 0} ->
        send parent, :ok
        send pid, :end
      {pid, n} ->
        pingpong_lf_body(pid, n)
        loop(parent)
    end
  end

  deflf pingpong_lf_body(pid, n) do
    send pid, {self, n-1}
  end
end
