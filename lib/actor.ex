defmodule Actor do
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
        spawn(fn ->
          init_context group
          receiveMsg
        end)
      end

      def spawn_on_node(node, group \\ nil) do
        Node.spawn(node , fn ->
          init_context group
          receiveMsg
        end)
      end

      defp receiveMsg() do
        receive do
          {unquote(@endMsg), client} ->
            send client, {:ok}
          {unquote(@msg), client, msg} ->
            res = apply(__MODULE__, unquote(@funcName), [msg])
            send client, res
            receiveMsg
        end
      end
    end
  end

  defp receiveRet() do
    receive do
      res -> res
    end
  end

  def callEnd(pid) do
    send pid, {@endMsg, self}
    receiveRet
  end

  def callMsg(pid, msg) do
    send pid, {@msg, self, msg}
    receiveRet
  end
end
