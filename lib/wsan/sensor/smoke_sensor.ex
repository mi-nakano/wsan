defmodule Wsan.SmokeSensor do
  require Logger
  alias Wsan.Event, as: Event

  @sensor_type :smoke

  def spawn(parent_pid, sensor_id) do
    spawn(fn ->
      routine parent_pid, sensor_id
    end)
  end

  defp send_data(parent_pid, sensor_id, data) do
    send_data = %Event{type: @sensor_type, sensor_pid: self, sensor_id: sensor_id, value: data}
    Wsan.Actor.call_msg(parent_pid, send_data)
  end

  defp routine(parent_pid, sensor_id) do
    data = sense()
    send_data(parent_pid, sensor_id, data)
    Process.sleep(Enum.random([300, 500, 1000]))
    routine parent_pid, sensor_id
  end

  defp sense() do
    data = Enum.random([true, false])
    Logger.info("sense! data=#{data}", type: :sensor)
    data
  end
end
