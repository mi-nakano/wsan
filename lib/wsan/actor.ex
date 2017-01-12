defmodule Wsan.Actor do
  use ContextEX
  require Logger
  alias Wsan.Sensor.Event, as: Event

  @msg :msg

  def start(actor_id, group \\ nil) do
    print(actor_id, "----- start -----")
    init_context group
    loop(actor_id)
  end

  deflf loop(actor_id), %{:status => :emergency} do
    # do something
    print(actor_id, "loop: Status is Emergency!")
    Process.sleep 100
    loop(actor_id)
  end
  deflf loop(actor_id), %{:temperature => :high, :smoke => true} do
    print(actor_id, "loop: Emergency occured!")
    cast_activate_group(:actor, %{:status => :emergency})
    loop(actor_id)
  end
  deflf loop(actor_id) do
    receive do
      {@msg, _sender, msg} ->
        receive_msg(actor_id, msg)
        loop(actor_id)
    end
    loop(actor_id)
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


  defp print(actor_id, string), do: Logger.info("Actor#{actor_id}: #{string}", type: :actor)
  defp print(msg), do: Logger.info(inspect(msg), type: :actor)

  def cast_msg(pid, msg) do
    send pid, {@msg, self(), msg}
  end
end
