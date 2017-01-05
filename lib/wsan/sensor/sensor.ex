defmodule Wsan.Sensor do
  require Logger
  require Wsan.Actor
  alias Wsan.Event, as: Event

  def start(parent_pid, sensor_id) do
    spawn(fn ->
      routine parent_pid, sensor_id
    end)
  end

  defp sendData(parent_pid, sensor_id, data) do
    send_data = %Event{type: :data, sensor_pid: self, sensor_id: sensor_id, value: data}
    Wsan.Actor.callMsg(parent_pid, send_data)
  end

  defp routine(parent_pid, sensor_id) do
    data = sense()
    sendData(parent_pid, sensor_id, data)
    Process.sleep(Enum.random([300, 500, 1000]))
    routine parent_pid, sensor_id
  end

  defp sense() do
    data = Enum.random(1..5)
    Logger.info("sense! data=#{data}", type: :sensor)
    data
  end
end
