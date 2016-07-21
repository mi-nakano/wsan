defmodule WSANNode do
  @moduledoc """
  WSANNode. If we use this module, we must impl routine/1 function in user module

  """


  @getLayerMsg :getLayer
  @isActiveMsg :isActive
  @activateMsg :activate
  @activateGroupMsg :activateGroup
  @endMsg :end
  @msg :msg

  @funcName :routine

  defmacro __using__(_opts) do
    quote do
      require ContextEX
      import unquote(__MODULE__)

      def spawnNode(group \\ nil) do
        spawn(fn ->
          initLayer group
          receiveMsg
        end)
      end

      defp receiveMsg() do
        receive do
          {unquote(@getLayerMsg), client} ->
            send client, getActiveLayers
            receiveMsg
          {unquote(@isActiveMsg), client, layer} ->
            send client, isActive?(layer)
            receiveMsg
          {unquote(@activateMsg), map} ->
            activateLayer map
            receiveMsg
          {unquote(@activateGroupMsg), group, map} ->
            activateLayer group, map
            receiveMsg
          {unquote(@endMsg), client} ->
            send client, {:ok}
          {unquote(@msg), client, msg} ->
            res = apply(__MODULE__, unquote(@funcName), msg)
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

  def callGetLayers(pid) do
    send pid, {@getLayerMsg, self}
    receiveRet
  end

  def callIsActive?(pid, layer) do
    send pid, {@isActiveMsg, self, layer}
    receiveRet
  end

  def castActivate(pid, map) do
    send pid, {@activateMsg, map}
  end

  def castActivateGroup(pid, group, map) do
    send pid, {@activateGroupMsg, group, map}
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
