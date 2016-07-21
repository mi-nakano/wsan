defmodule WSANNode do
  @moduledoc """
  WSANNode. If we use this module, we must impl routine/1 function in user module

  """


  @getLayerMsg :getLayer
  @isActiveMsg :isActive
  @activateMsg :activate
  @activateGroupMsg :activateGroup
  @msg :msg
  @endMsg :end

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
          {unquote(@getLayerMsg), caller} ->
            send caller, getActiveLayers
            receiveMsg
          {unquote(@isActiveMsg), caller, layer} ->
            send caller, isActive?(layer)
            receiveMsg
          {unquote(@activateMsg), map} ->
            activateLayer map
            receiveMsg
          {unquote(@activateGroupMsg), group, map} ->
            activateLayer group, map
            receiveMsg
          {unquote(@endMsg), caller} ->
            send caller, {:ok}
          {unquote(@msg), caller, msg} ->
            res = routine(msg)
            send caller, res
            receiveMsg
        end
      end
    end
  end


  defmacro requestLayer(pid) do
    quote do
      send unquote(pid), {unquote(@getLayerMsg), self}
    end
  end

  defmacro requestIsActive(pid, layer) do
    quote do
      send unquote(pid), {unquote(@isActiveMsg), self, unquote(layer)}
    end
  end

  defmacro activateNode(pid, map) do
    quote do
      send unquote(pid), {unquote(@activateMsg), unquote(map)}
    end
  end

  defmacro requestActivateGroup(pid, group, map) do
    quote do
      send unquote(pid), {unquote(@activateGroupMsg), unquote(group), unquote(map)}
    end
  end

  defmacro sendEnd(pid) do
    quote do
      send unquote(pid), {unquote(@endMsg), self}
    end
  end

  defmacro sendMsg(pid, msg) do
    quote do
      send unquote(pid), {unquote(@msg), self, unquote(msg)}
    end
  end
end
