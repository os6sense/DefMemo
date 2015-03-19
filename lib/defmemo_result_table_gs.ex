defmodule DefMemo.ResultTable.GS do
  @behaviour DefMemo.ResultTable

  @moduledoc """
    GenServer backing store for the results of the function calls.
  """
  use GenServer
   
  def start_link do 
    GenServer.start_link(__MODULE__, HashDict.new, name: :result_table)
  end
   
  def get(fun, args) do
    GenServer.call(:result_table, { :get, fun, args })
  end
    
  def put(fun, args, result) do
    GenServer.cast(:result_table, { :put, fun, args, result })
    result
  end

  def handle_call({ :get, fun, args }, _sender, dict) do
     if (status = HashDict.fetch(dict, { fun, args })) == :error, 
      do: { :reply, { :miss, nil }, dict }, 
      else: { :reply, { :hit, elem(status, 1) }, dict }
  end
   
  def handle_cast({ :put, fun, args, result }, dict) do
    { :noreply,  HashDict.put(dict, { fun, args }, result) }
  end
end
