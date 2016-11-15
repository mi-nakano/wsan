defmodule Experiment.Analyzer do

  # funcを実行し、それにかかった時間を出力
  def measure(func, args \\ []) do
    prev = System.os_time()

    # do something
    apply(func, args)

    diff = System.os_time() - prev
    convert(diff)
  end

  def analyze(filepath) do
    {:ok, fp} = File.open(filepath, [:read, :utf8])
    # コメント行を無視して全て数値に変換
    list = IO.stream(fp, :line)
      |> Enum.filter_map(fn(line) -> String.at(line, 0) != "#" end,
                         fn(line) -> line |> String.trim |> String.to_integer end)

    count = Enum.count(list)
    sum = list |> Enum.reduce(0, fn(x, acc) -> x + acc end)

    IO.write "COUNT: "
    IO.inspect count
    IO.write "SUM: "
    IO.inspect sum
    IO.write "AVG: "
    IO.inspect(sum / count)
    :ok
  end

  # 時間の単位をnsに変換
  defp convert(time) do
    System.convert_time_unit(time, :native, :nanoseconds)
  end
end
