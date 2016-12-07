defmodule Experiment.Activation do
  require Wsan.Router
  import Experiment.Analyzer
  use ContextEX

  @group_name :my_group
  @context %{:staus => :end}


  def measure_activation(num_process) do
    pid_list = for n <- 1..num_process do
      p = Wsan.Router.route(2, __MODULE__, :routine, [self])
    end

    for p <- pid_list do
      send p, :start
    end

    measure(fn ->
      cast_activate_group(@group_name, @context)

      for _ <- pid_list do
        receive do
          result -> result
        end
      end
    end)
  end

  def routine(parent) do
    init_context(@group_name)

    # メッセージがくるまで待機
    receive do
      :start -> :start
    end

    result = loop()
    send parent, result
  end

  defp loop() do
    if is_end?() do
      :ok
    else
      loop()
    end
  end

  deflf is_end?(), @context do
    true
  end
  deflf is_end?() do
    false
  end
end
