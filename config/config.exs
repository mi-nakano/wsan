# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :wsan, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:wsan, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

# Replace localhost to your PC-name
config :wsan, :routing_table, [
  {1, :"pi@192.168.120.162"},
  {2, :"pi@192.168.120.163"},
  {3, :"pi@192.168.120.164"},
  {4, :"pi@192.168.120.165"},
]

# logger config
config :logger,
  backends: [{LoggerFileBackend, :sensor}, {LoggerFileBackend, :actor}]

config :logger, :sensor,
  path: "./log/wsan/sensor.log",
  level: :info,
  metadata_filter: [type: :sensor]
config :logger, :actor,
  path: "./log/wsan/actor.log",
  level: :info,
  metadata_filter: [type: :actor]
