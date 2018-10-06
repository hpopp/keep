use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :keep, KeepWeb.Endpoint,
  http: [port: System.get_env("PORT") || 4041],
  server: false

config :keep, file_path: 'disk_storage_test.dets'

# Print only warnings and errors during test
config :logger, level: :warn
