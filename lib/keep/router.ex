defmodule Keep.Router do
  use Plug.Router

  alias Keep.Store

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  plug(:match)
  plug(:dispatch)

  get "/healthz" do
    send_resp(conn, 200, ~s({"status": "ok"}))
  end

  get "/data/:id" do
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

  put "/data/:id" do
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

  delete "/data/:id" do
    case Store.delete(id) do
      :ok ->
        send_resp(conn, :no_content, "")

      :error ->
        conn
        |> put_status(500)
        |> json(%{success: false, error: :open_table_failure})
    end
  end

  match _ do
    send_resp(conn, 404, ~s({"success": false, "error": "not_found"}))
  end

  @doc """
  Sends JSON response.
  It uses the configured `:json_library` under the `:phoenix`
  application for `:json` to pick up the encoder module.
  ## Examples
      iex> json(conn, %{id: 123})
  """
  @spec json(Plug.Conn.t(), term) :: Plug.Conn.t()
  def json(conn, data) do
    response = Jason.encode_to_iodata!(data)

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(conn.status || 200, response)
  end
end
