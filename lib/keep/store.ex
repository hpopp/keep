defmodule Keep.Store do
  @moduledoc """
  Documentation for Keep.Store.
  """

  require Logger

  @table :storage
  def opts, do: [type: :set, file: file_path()]
  def file_path, do: Application.get_env(:keep, :file_path)

  def get(id) do
    case :dets.open_file(@table, opts()) do
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
        error |> inspect() |> Logger.error()
        :error
    end
  end

  def put(id, val) do
    case :dets.open_file(@table, opts()) do
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
    case :dets.open_file(@table, opts()) do
      {:ok, table} ->
        :dets.delete(table, id)
        :dets.close(file_path())
        :ok

      _ ->
        :error
    end
  end
end
