defmodule Experiment.Pingpong do
  require Wsan.Router
  import Experiment.Analyzer
  use ContextEX


  def measure_pingpong(num_token) do
    # prepare
    n1 = Wsan.Router.route(1, __MODULE__, :pingpong, [self])
    n2 = Wsan.Router.route(2, __MODULE__, :pingpong, [self])

    # do something
    measure(fn ->
      send n1, {n2, num_token}
      receive do
        :ok -> :ok
      end
    end)
  end

  def measure_pingpong_multiple(num_token, num_pairs) do
    # prepare
    pairs = for _ <- 1..num_pairs do
      n1 = Wsan.Router.route(1, __MODULE__, :pingpong, [self])
      n2 = Wsan.Router.route(2, __MODULE__, :pingpong, [self])
      {n1, n2}
    end

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
    n1 = Wsan.Router.route(1, __MODULE__, :pingpong_lf, [self])
    n2 = Wsan.Router.route(2, __MODULE__, :pingpong_lf, [self])

    # do something
    measure(fn ->
      send n1, {n2, num_token}
      receive do
        :ok -> :ok
      end
    end)
  end

  def measure_pingpong_multiple_lf(num_token, num_pairs) do
    # prepare
    pairs = for _ <- 1..num_pairs do
      n1 = Wsan.Router.route(1, __MODULE__, :pingpong_lf, [self])
      n2 = Wsan.Router.route(2, __MODULE__, :pingpong_lf, [self])
      {n1, n2}
    end

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
