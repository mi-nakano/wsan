defmodule Experiment.Analyzer do

  # funcを実行し、それにかかった時間を出力
  def measure(func, args \\ []) do
    start_time = measure_time()
    # do something
    apply(func, args)
    end_time = measure_time()
    diff = end_time - start_time
    convert(diff)
  end

  def measure_time(), do: System.os_time()

  def analyze(filepath) do
    fp = File.open!(filepath, [:read, :utf8])
    # コメント行を無視して全て数値に変換
    list = IO.stream(fp, :line)
      |> Enum.filter_map(fn(line) -> String.at(line, 0) != "#" end,
                         fn(line) -> line |> String.trim |> String.to_integer end)

    count = Enum.count(list)
    sum = list |> Enum.reduce(0, fn(x, acc) -> x + acc end)

    IO.write "COUNT: "
    IO.inspect count
    IO.write "SUM(milliSec): "
    IO.inspect sum
    IO.write "AVG(milliSec): "
    IO.inspect(sum / count)
    :ok
  end

  # 時間の単位をmsに変換
  def convert(time) do
    System.convert_time_unit(time, :native, :milliseconds)
  end
end
