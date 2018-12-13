defmodule Keep.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: Keep.Router, options: [port: 4040])
    ]

    opts = [strategy: :one_for_one, name: Keep.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
