defmodule Keep.Store do
  @moduledoc """
  Documentation for Keep.Store.
  """

  @opts [type: :set]

  def file_path, do: Application.get_env(:keep, :file_path)

  def get(id) do
    case :dets.open_file(file_path(), @opts) do
      {:ok, table} ->
        case :dets.lookup(table, id) do
          [] ->
            :dets.close(file_path())
            {:ok, nil}

          [{^id, val}] ->
            :dets.close(file_path())
            {:ok, val}

          _ ->
            :error
        end

      error ->
        IO.inspect(error)
        :error
    end
  end

  def put(id, val) do
    case :dets.open_file(file_path(), @opts) do
      {:ok, table} ->
        case :dets.insert(table, {id, val}) do
          :ok ->
            :dets.close(file_path())
            :ok

          _error ->
            :dets.close(file_path())
            :error
        end

      _ ->
        :error
    end
  end

  def delete(id) do
    case :dets.open_file(file_path(), @opts) do
      {:ok, table} ->
        :dets.delete(table, id)
        :dets.close(file_path())
        :ok

      _ ->
        :error
    end
  end
end
