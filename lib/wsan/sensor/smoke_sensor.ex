defmodule Wsan.Sensor.SmokeSensor do
  @sensor_type :smoke
  use Wsan.Sensor.AbstractSensor

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
