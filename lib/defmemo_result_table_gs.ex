defmodule DefMemo.ResultTable.GS do
  @behaviour DefMemo.ResultTable

  @moduledoc """
    GenServer backing store for the results of the function calls.
  """
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, Map.new, name: :result_table)
  end

  def get(fun, args) do
    GenServer.call(:result_table, { :get, fun, args })
  end

  def delete(fun, args) do
    GenServer.call(:result_table, { :delete, fun, args })
  end

  def put(fun, args, result) do
    GenServer.cast(:result_table, { :put, fun, args, result })
    result
  end

  def handle_call({ :get, fun, args }, _sender, map) do
    reply(Map.fetch(map, { fun, args }), map)
  end

  def handle_call({ :delete, fun, args }, _sender, map) do
    reply({ :ok, nil }, Map.delete(map, { fun, args }))
  end

  def handle_cast({ :put, fun, args, result }, map) do
    { :noreply, Map.put(map, { fun, args }, result) }
  end

  defp reply(:error, map) do
    { :reply, { :miss, nil }, map }
  end

  defp reply({:ok, val}, map) do
   { :reply, { :hit, val }, map }
  end

end
