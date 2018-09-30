defmodule KeepWeb.Router do
  use KeepWeb, :router

  pipeline :api do
    plug(:accepts, ["text", "json"])
  end

  scope "/", KeepWeb do
    pipe_through(:api)

    scope "/data" do
      get("/:id", ActionController, :get)
      put("/:id", ActionController, :put)
      delete("/:id", ActionController, :delete)
    end
  end
end
