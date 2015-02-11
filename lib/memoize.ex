
defmodule Memoize do
  @moduledoc ~S"""
    Adapted from : (Gustavo Brunoro) https://gist.github.com/brunoro/6159378

    A simple Memoize macro, the main point of note being that it can
    handle identical function signatures in differing modules.

    # See tests and test_helper for examples.
  """
  alias Memoize.ResultTable

  defdelegate start_link, to: ResultTable

  @doc ~S"""
    Defines a function as being memoized. Note that Memoize.start_link 
    must be called before calling a method defined with defmacro.

    # Example:
      defmemo fibs(0), do: 0
  """
  defmacro defmemo(head = {name, _meta, vars}, do: body) do
    quote do
      def unquote(head) do
        sig = Module.concat(__MODULE__, unquote(name))
        case ResultTable.get( sig, unquote(vars)) do
          { :hit, value }  -> value
          { :miss, nil } -> ResultTable.put sig,
                                            unquote(vars), 
                                            unquote(body)
        end
      end
    end
  end
   
  defmodule ResultTableETS do
     


  end


  defmodule ResultTable do
    @moduledoc ~S"""
      GenServer backing store for the results of the function calls.
    """
    use GenServer
     
    def start_link, 
      do: GenServer.start_link(__MODULE__, HashDict.new, name: :result_table)
     
    def get(fun, args), 
      do: GenServer.call(:result_table, { :get, fun, args })
      
    def put(fun, args, result) do
      GenServer.cast(:result_table, { :put, fun, args, result })
      result
    end

    def handle_call({ :get, fun, args }, _sender, dict) do
      if HashDict.has_key?(dict, { fun, args }),
        do:   { :reply, { :hit, dict[{  fun, args }] }, dict },
        else: { :reply, { :miss, nil }, dict } 
    end
     
    def handle_cast({ :put, fun, args, result }, dict), 
      do: { :noreply, HashDict.put(dict, { fun, args }, result) }

  end
end
