defmodule Memoize do

  alias Memoize.ResultTable.GS,     as: ResultTable

  defdelegate start_link, to: ResultTable

  @moduledoc ~S"""
    Adapted from : (Gustavo Brunoro) https://gist.github.com/brunoro/6159378

    A simple Memoize macro, the main point of note being that it can
    handle identical function signatures in differing modules.

    # See tests and test_helper for examples.
  """

  @doc """
    Defines a function as being memoized. Note that Memoize.start_link 
    must be called before calling a method defined with defmacro.

    # Example:
      defmodule FibMemo do
        import Memoize
         
        defmemo fibs(0), do: 0
        defmemo fibs(1), do: 1
        defmemo fibs(n), do: fibs(n - 1) + fibs(n - 2)
      end
  """
  defmacro defmemo(head = {:when, _, vars = [ {_, _, f_vars} | tail ] }, do: body) do
    quote do
      def unquote(head) do
        sig = Module.concat(__MODULE__, "when #{unquote(Macro.to_string vars)}")
        args = unquote(f_vars)# Enum.map(unquote(f_vars), fn(v) -> v end)
        #args = Enum.map(unquote(f_vars), fn(v) -> v end) 
        #IO.puts inspect "*******#{sig}"
        #IO.puts inspect "*******#{args}"

        case ResultTable.get(sig, args) do
          { :hit, value }   -> value
          { :miss, nil }    -> ResultTable.put sig, args, unquote(body)
        end
      end
    end
  end

  defmacro defmemo(head = {name, meta, vars}, do: body) do
    quote do
      def unquote(head) do
        sig = Module.concat(__MODULE__, unquote(name))

        case ResultTable.get(sig, unquote(vars)) do
          { :hit, value } -> value
          { :miss, nil }  -> ResultTable.put sig, unquote(vars), unquote(body)
        end
      end
    end
  end

  defmacro deathmemo(l) do
    quote do
      raise "Ryuk wants an apple!"
    end
  end
end

