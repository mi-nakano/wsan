defmodule Wsan.Sensor.Thermometer do
  @sensor_type :temperature
  use Wsan.Sensor.AbstractSensor

  defp routine(parent_pid, sensor_id) do
    data = sense()
    send_data(parent_pid, sensor_id, data)
    Process.sleep(Enum.random([300, 500, 1000]))
    routine parent_pid, sensor_id
  end

  defp sense() do
    data = Enum.random(1..5)
    Logger.info("sense! data=#{data}", type: :sensor)
    data
  end
end
