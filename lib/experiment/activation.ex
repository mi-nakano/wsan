defmodule Experiment.Activation do
  require Wsan.Router
  import Experiment.Analyzer
  use ContextEX

  def measure_activation() do
    p = Wsan.Router.route(2, __MODULE__, :routine, [self])
    send p, :start
    receive do
      result -> result
    end
  end

  def routine(parent) do
    init_context()

    # メッセージがくるまで待機
    receive do
      :start -> :start
    end

    cast_activate_layer(%{:status => :end})
    result = loop(0)
    send parent, result
  end

  defp loop(n) do
    if is_end?() do
      n
    else
      routine(n+1)
    end
  end

  deflf is_end?(), %{:status => :end} do
    true
  end
  deflf is_end?() do
    false
  end
end
