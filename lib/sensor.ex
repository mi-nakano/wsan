defmodule Sensor do

  def start(parentPid) do
    spawn(fn ->
      routine parentPid
    end)
  end

  defp sendData(parentPid, data) do
    send parentPid, {:data, self, data}
  end

  defp routine(parentPid) do
    data = sense()
    sendData(parentPid, data)
    Process.sleep(Enum.random([300, 500, 1000]))
    routine parentPid
  end

  defp sense() do
    Enum.random(1..5)
  end
end