defmodule Sample do
  use ContextEX  #ライブラリの使用

  #各コンテキストでの振る舞いを定義 (deflfマクロを使用)
  deflf func(), %{:status => :normal} do
    IO.puts "context = normal"
  end
  deflf func(), %{:status => :emergency} do
    IO.puts "context = emergency!"
  end
  deflf func() do
    IO.puts "context = default"
  end

  def start(groupName) do
    spawn(fn ->
      init_context(groupName)     #コンテキストの初期化. グループ名を設定
      receiveMsg()         #メッセージを待つ
    end)
  end
  def receiveMsg() do
    receive do
      msg -> func()
    end
    receiveMsg()  #再帰
  end
end
