defmodule Experiment do
  require Wsan.Router
  use ContextEX

  @num 100

  def start_pingpong() do
    # prepare
    n1 = Wsan.Router.route(1, Experiment, :pingpong, [self])
    n2 = Wsan.Router.route(2, Experiment, :pingpong, [self])
    IO.write "n1="
    IO.inspect n1
    IO.write "n2="
    IO.inspect n2

    # measure
    prev = System.os_time()

    # do something
    send n1, {n2, @num}
    receive do
      :ok -> :ok
    end

    # measure
    diff = System.os_time() - prev
    IO.write "Time: "
    IO.inspect diff
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
