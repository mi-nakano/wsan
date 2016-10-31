#!/bin/sh

DEFAULT_NUM=2
NODE_NAME="node"

echo "Start Experiment"

# 立ち上げるノード数. 第一引数かデフォルト値をとる
num=${1:-$DEFAULT_NUM}


for i in `seq 1 ${num}`; do
  echo "start ${NODE_NAME}${i}"
  # Elixirの起動
  `iex --sname "${NODE_NAME}${i}" -S mix` &
done


# Ctrl-Cで子プロセスをkill
trap 'kill $(jobs -p)' EXIT
wait
