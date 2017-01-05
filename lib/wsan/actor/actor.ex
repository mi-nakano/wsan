defmodule Wsan.Actor do
  @moduledoc """
  Actor module. If we use this module, we must impl routine/1 function in user module.
  If you import this module, only message-sending functions are import in your module.

  """


  @endMsg :end
  @msg :msg

  @funcName :routine

  defmacro __using__(_opts) do
    quote do
      require ContextEX
      import unquote(__MODULE__)

      def spawn(group \\ nil) do
        spawn(fn -> start(group) end)
      end
      def start(group \\ nil) do
        init_context group
        receive_msg
      end

      defp receive_msg() do
        receive do
          {unquote(@endMsg), client} ->
            send client, {:ok}
          {unquote(@msg), client, msg} ->
            res = apply(__MODULE__, unquote(@funcName), [msg])
            send client, res
            receive_msg
        end
      end
    end
  end

  defp receive_ret() do
    receive do
      res -> res
    end
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
end
