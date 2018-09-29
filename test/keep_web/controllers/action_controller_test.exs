defmodule KeepWeb.ActionControllerTest do
  use KeepWeb.ConnCase

  alias Keep.Store

  describe "GET /:id" do
    test "returns val if found", %{conn: conn} do
      Store.put("example", "good")

      conn = get(conn, "/data/example")
      assert response(conn, 200) == "\"good\""

      Store.delete("example")
    end

    test "returns 404 if not found", %{conn: conn} do
      conn = get(conn, "/data/bad_key")
      assert response(conn, 404) == ""
    end
  end

  describe "PUT /:id" do
    test "puts value for given id", %{conn: conn} do
      conn = put(conn, "/data/thing")
      assert response(conn, 201) == ""

      assert not is_nil(Store.get("thing"))
      Store.delete("thing")
    end
  end
end
