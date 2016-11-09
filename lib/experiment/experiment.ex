defmodule Experiment do
  require Wsan

  @num 100

  def start() do
    prev = System.os_time()

    # do something
    for n <- 1..@num do
      IO.write "."
    end
    Wsan.start

    diff = System.os_time() - prev

    IO.puts ""
    IO.write "Time: "
    IO.inspect diff
  end
end
