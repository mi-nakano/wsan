defmodule Experiment do
  require Wsan.Router
  use ContextEX

  @num 100

  # funcを実行し、それにかかった時間を出力
  def measure(func, args \\ []) do
    prev = System.os_time()

    # do something
    apply(func, args)

    diff = System.os_time() - prev
    IO.write "Time: "
    IO.inspect diff
    diff
  end

  def start_pingpong() do
    # prepare
    n1 = Wsan.Router.route(1, Experiment, :pingpong, [self])
    n2 = Wsan.Router.route(2, Experiment, :pingpong, [self])

    # do something
    measure(fn ->
      send n1, {n2, @num}
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
end
