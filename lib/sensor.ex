defmodule Sensor do

  def start(parentPid, sensorId) do
    spawn(fn ->
      routine parentPid, sensorId
    end)
  end

  defp sendData(parentPid, sensorId, data) do
    data = %Event{type: :data, from: self, id: sensorId, value: data, time: :dummy}
    Actor.callMsg(parentPid, data)
  end

  defp routine(parentPid, sensorId) do
    data = sense()
    sendData(parentPid, sensorId, data)
    Process.sleep(Enum.random([300, 500, 1000]))
    routine parentPid, sensorId
  end

  defp sense() do
    Enum.random(1..5)
  end
end
