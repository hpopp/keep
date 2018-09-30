defmodule KeepWeb.ActionController do
  use Phoenix.Controller

  alias Keep.Store

  def get(conn, %{"id" => id}) do
    case Store.get(id) do
      :error ->
        conn
        |> put_status(500)
        |> json(%{success: false, error: :open_table_failure})

      {:ok, nil} ->
        send_resp(conn, :not_found, "")

      {:ok, val} ->
        case get_req_header(conn, "content-type") do
          ["application/json"] -> json(conn, val)
          [] -> send_resp(conn, 200, val)
        end
    end
  end

  def put(conn, %{"id" => id}) do
    {:ok, val, conn} = Plug.Conn.read_body(conn)

    case Store.put(id, val) do
      :ok ->
        send_resp(conn, :created, "")

      :error ->
        conn
        |> put_status(500)
        |> json(%{success: false})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Store.delete(id) do
      :ok ->
        send_resp(conn, :no_content, "")

      :error ->
        conn
        |> put_status(500)
        |> json(%{success: false, error: :open_table_failure})
    end
  end
end
