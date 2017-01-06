defmodule Wsan.Actor do
  use ContextEX
  require Logger
  alias Wsan.Sensor.Event, as: Event

  @end_msg :end
  @msg :msg

  def start(id, group \\ nil) do
    print(id, "----- start -----")
    init_context group

    # センサーノードを宣言
    Wsan.Sensor.Thermometer.spawn(self(), 1)
    Wsan.Sensor.SmokeSensor.spawn(self(), 2)

    loop id
  end

  defp loop(id) do
    receive do
      {@end_msg, sender} ->
        send sender, {:ok}
        print(id, "----- end -----")
      {@msg, _sender, msg} ->
        receive_msg(id, msg)
        loop id
    after
      1_00 ->
        routine(id)
        loop(id)
    end
  end


  # sensorノードからのメッセージ受け取り
  defp receive_msg(id, %Event{type: :temperature, value: val}) when val >= 5 do
    print(id, "Recieve: temperature, val=#{val}")
    cast_activate_layer(%{:temperature => :high})
  end
  defp receive_msg(id, %Event{type: :temperature, value: val}) when val <= 3 do
    print(id, "recieve: temperature, val=#{val}")
    cast_activate_layer(%{:temperature => :low})
  end
  defp receive_msg(id, %Event{type: :smoke, value: val}) when val == true do
    print(id, "Recieve: smoke, val=#{val}")
    cast_activate_layer(%{:smoke => true})
  end
  defp receive_msg(id, %Event{type: :smoke, value: val}) when val == false do
    print(id, "Recieve: smoke, val=#{val}")
    cast_activate_layer(%{:smoke => false})
  end
  defp receive_msg(id, msg) do
    print(id, "Recieve: msg")
    print(msg)
  end

  # 文脈に応じた処理
  deflf routine(id), %{:status => :emergency} do
    # do something
    print(id, "Routine: Status is Emergency!")
  end
  deflf routine(id), %{:temperature => :high, :smoke => true} do
    print(id, "Routine: Emergency occured!")
    cast_activate_group(:actor, %{:status => :emergency})
  end
  deflf routine(id) do
    print(id, "Routine: Default")
  end


  defp print(id, string), do: Logger.info("Actor#{id}: #{string}", type: :actor)
  defp print(msg), do: Logger.info(inspect(msg), type: :actor)

  def call_end(pid) do
    send pid, {@end_msg, self()}
    receive do
      res -> res
    end
  end

  def cast_msg(pid, msg) do
    send pid, {@msg, self(), msg}
  end
end
