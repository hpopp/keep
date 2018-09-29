use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :keep, KeepWeb.Endpoint,
  http: [port: 4001],
  server: false

config :keep, file_path: "test_storage.dets"

# Print only warnings and errors during test
config :logger, level: :warn
