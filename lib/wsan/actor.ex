defmodule Wsan.Actor do
  use ContextEX
  require Logger

  @endMsg :end
  @msg :msg

  def start(group \\ nil) do
    init_context group

    # センサーノードを宣言
    Wsan.Sensor.start(self, 1)
    Wsan.Sensor.start(self, 2)

    receive_msg
  end

  defp receive_msg() do
    receive do
      {@endMsg, client} ->
        send client, {:ok}
      {@msg, client, msg} ->
        res = routine(msg)
        send client, res
        receive_msg
    end
  end


  deflf routine(msg), %{:categoryA => :layer1} do
    Logger.info("msg came @layer1!!!!!!!!!", type: :actor)
    Logger.info(inspect(msg), type: :actor)
  end
  deflf routine(msg) do
    Logger.info("msg came @default", type: :actor)
    Logger.info(inspect(msg), type: :actor)

    if (msg.value == 5), do: cast_activate_layer(%{:categoryA => :layer1})
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
  def call_msg(pid, msg) do
    cast_msg(pid, msg)
    receive_ret
  end

  defp receive_ret() do
    receive do
      res -> res
    end
  end
end
