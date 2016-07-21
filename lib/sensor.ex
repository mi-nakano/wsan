defmodule Sensor do

  def start(actorPid) do
    spawn(fn ->
      routine actorPid
    end)
  end

  defp sendData(actorPid, data) do
    send actorPid, {:data, self, data}
  end

  defp routine(actorPid) do
    data = sense()
    sendData(actorPid, data)
    Process.sleep(Enum.random([300, 500, 1000]))
    routine actorPid
  end

  defp sense() do
    Enum.random(1..5)
  end
end
