defmodule Wsan.Actor do
  use ContextEX
  require Logger

  @endMsg :end
  @msg :msg

  def start(id, group \\ nil) do
    init_context group

    # センサーノードを宣言
    Wsan.Sensor.Thermometer.spawn(self, 1)
    Wsan.Sensor.SmokeSensor.spawn(self, 2)

    loop id
  end

  defp loop(id) do
    receive do
      {@endMsg, sender} ->
        send sender, {:ok}
        print(id, "end.")
      {@msg, sender, msg} ->
        receive_msg(id, sender, msg)
        loop id
    after
      1_00 ->
        routine(id)
        loop(id)
    end
  end


  defp print(id, string), do: Logger.info("Actor#{id}: #{string}", type: :actor)
  defp print(msg), do: Logger.info(inspect(msg), type: :actor)

  defp receive_msg(id, sender, msg) do
    print(id, "msg came from...")
    print(sender)
    print(msg)
  end

  deflf routine(id), %{:status => :emergency} do
    # do something
    print(id, "Emergency!")
  end
  deflf routine(id) do
    print(id, "Default")
  end


  def cast_end(pid) do
    send pid, {@endMsg, self}
  end
  def call_end(pid) do
    cast_end(pid)
    receive_ret
  end

  def cast_msg(pid, msg) do
    send pid, {@msg, self, msg}
  end

  defp receive_ret() do
    receive do
      res -> res
    end
  end
end
