defmodule Keep.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Keep.{Router, Store}
  alias Plug.Conn

  describe "GET /:id" do
    test "returns val if found" do
      Store.put("example", "good")

      conn = conn(:get, "/data/example") |> dispatch()
      assert response(conn, 200) == "good"

      Store.delete("example")
    end

    test "returns 404 if not found" do
      conn = conn(:get, "/data/bad_key") |> dispatch()
      assert response(conn, 404) == ""
    end
  end

  describe "PUT /:id" do
    test "puts value for given id" do
      conn = conn(:put, "/data/thing") |> dispatch()
      assert response(conn, 201) == ""

      assert not is_nil(Store.get("thing"))
      Store.delete("thing")
    end
  end

  def response(%Plug.Conn{status: status, resp_body: body}, given) do
    given = Conn.Status.code(given)

    if given == status do
      body
    else
      raise "expected response with status #{given}, got: #{status}, with body:\n#{body}"
    end
  end

  def dispatch(conn) do
    Router.call(conn, Keep.Router.init([]))
  end
end
