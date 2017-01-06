defmodule Experiment.Activation do
  require Router
  import Experiment.Analyzer
  use ContextEX

  @group_name :my_group
  @context %{:staus => :end}

  # 対照実験の速度を測定
  def measure_activation_comparison(num_process) do
    pid_list = for _ <- 1..num_process do
      Router.route(2, __MODULE__, :echo, [self])
    end
    measure(fn ->
      for pid <- pid_list do
        send pid, :ok
      end
      for _ <- pid_list do
        receive do
          result -> result
        end
      end
    end)
  end

  # 到着したメッセージをparentに送り返して終了する
  def echo(parent) do
    receive do
      msg -> send parent, msg
    end
  end

  # activationの速度を測定
  def measure_activation(num_process) do
    pid_list = for _ <- 1..num_process do
      Router.route(2, __MODULE__, :routine, [])
    end

    time = measure(fn ->
      call_activate_group(@group_name, @context)
    end)

    for p <- pid_list do
      send p, :end
    end

    time
  end

  def routine() do
    init_context(@group_name)

    # メッセージがくるまで待機
    receive do
      :end -> :end
    end
  end
end
