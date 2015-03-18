defmodule DefMemo.Redis.Api do
  use Exredis

  def set(client, key, value) do
    Exredis.Api.set(client, key, value)
  end

  def get(client, key) do
    Exredis.Api.get(client, key)
  end

end

defmodule DefMemo.ResultTable.Redis do
  @behaviour DefMemo.ResultTable

  @moduledoc """
    Redis backing store for the results of the function calls.
  """
  use GenServer
   
  def start_link do 
    GenServer.start_link(__MODULE__, Exredis.start, name: :result_table)
  end
   
  def get(fun, args) do
    GenServer.call(:result_table, { :get, fun, args })
  end
    
  def put(fun, args, result) do
    GenServer.cast(:result_table, { :put, fun, args, result })
    result
  end

  def handle_call({ :get, fun, args }, _sender, client) do
    val = DefMemo.Redis.Api.get(client, {fun, args})

    if val != :undefined,
      do:   { :reply, { :hit, val }, client },
      else: { :reply, { :miss, nil }, client } 
  end

  def handle_cast({ :put, fun, args, result }, client) do
    DefMemo.Redis.Api.set(client, { fun, args }, result);
    { :noreply,  client }
  end
end
