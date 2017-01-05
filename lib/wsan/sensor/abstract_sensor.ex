defmodule Wsan.Sensor.AbstractSensor do

  # 使用するモジュール側で@sensor_typeを指定する。
  defmacro __using__(_opts) do
    quote do
      require Logger
      alias Wsan.Event, as: Event

      # spawn
      def spawn(parent_pid, sensor_id) do
        spawn(fn ->
          routine parent_pid, sensor_id
        end)
      end

      # アクターにデータを送信
      defp send_data(parent_pid, sensor_id, data) do
        send_data = %Event{type: @sensor_type, sensor_pid: self, sensor_id: sensor_id, value: data}
        Wsan.Actor.cast_msg(parent_pid, send_data)
      end

      # ログ出力
      defp print(id, string) do
        Logger.info("#{@sensor_type}#{id}: #{string}", type: :sensor)
      end

      # 1ループ毎の処理内容
      defp routine(parent_pid, sensor_id) do
        data = sense()
        send_data(parent_pid, sensor_id, data)
        Process.sleep(Enum.random([300, 500, 1000]))
        routine parent_pid, sensor_id
      end

      # 計測
      defp sense() do
        data = Enum.random([true, false])
        Logger.info("sense! data=#{data}", type: :sensor)
        data
      end

      # オーバーライド可能な関数
      defoverridable [routine: 2, sense: 0]
    end
  end
end
