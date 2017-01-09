defmodule Wsan.Actor do
  use ContextEX
  require Logger
  alias Wsan.Sensor.Event, as: Event

  @end_msg :end
  @msg :msg

  def start(actor_id, group \\ nil) do
    print(actor_id, "----- start -----")
    init_context group

    # センサーノードを宣言
    Wsan.Sensor.Thermometer.spawn(self(), 1)
    Wsan.Sensor.SmokeSensor.spawn(self(), 2)

    loop(actor_id)
  end

  defp loop(actor_id) do
    receive do
      {@end_msg, sender} ->
        send sender, {:ok}
        print(actor_id, "----- end -----")
      {@msg, _sender, msg} ->
        receive_msg(actor_id, msg)
        loop(actor_id)
    after
      1_00 ->
        routine(actor_id)
        loop(actor_id)
    end
  end


  # sensorノードからのメッセージ受け取り
  defp receive_msg(actor_id, %Event{type: :temperature, value: val}) when val >= 5 do
    print(actor_id, "Recieve: temperature, val=#{val}")
    cast_activate_layer(%{:temperature => :high})
  end
  defp receive_msg(actor_id, %Event{type: :temperature, value: val}) when val <= 3 do
    print(actor_id, "recieve: temperature, val=#{val}")
    cast_activate_layer(%{:temperature => :low})
  end
  defp receive_msg(actor_id, %Event{type: :smoke, value: val}) when val == true do
    print(actor_id, "Recieve: smoke, val=#{val}")
    cast_activate_layer(%{:smoke => true})
  end
  defp receive_msg(actor_id, %Event{type: :smoke, value: val}) when val == false do
    print(actor_id, "Recieve: smoke, val=#{val}")
    cast_activate_layer(%{:smoke => false})
  end
  defp receive_msg(actor_id, msg) do
    print(actor_id, "Recieve: msg")
    print(msg)
  end

  # 文脈に応じた処理 layered function
  deflf routine(actor_id), %{:status => :emergency} do
    # do something
    print(actor_id, "Routine: Status is Emergency!")
  end
  deflf routine(actor_id), %{:temperature => :high, :smoke => true} do
    print(actor_id, "Routine: Emergency occured!")
    cast_activate_group(:actor, %{:status => :emergency})
  end
  deflf routine(actor_id) do
    print(actor_id, "Routine: Default")
  end


  defp print(actor_id, string), do: Logger.info("Actor#{actor_id}: #{string}", type: :actor)
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
