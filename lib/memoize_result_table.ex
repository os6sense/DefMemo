defmodule Memoize.ResultTable do
  use Behaviour

  defcallback start_link :: any | nil
  defcallback get(fun :: Fun, args :: List) :: any
  defcallback put(fun :: Fun, args :: List, result :: any) :: any
end
