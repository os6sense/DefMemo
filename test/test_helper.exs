ExUnit.start()

defmodule TimedFunction do
  def time(fun) do
    {start, return, stop} = {:erlang.now(), fun.(), :erlang.now()}
    {return, :timer.now_diff(stop, start) }
  end
end

defmodule FibMemo do
  import Memoize
   
  defmemo fibs(0), do: 0
  defmemo fibs(1), do: 1
  defmemo fibs(n), do: fibs(n - 1) + fibs(n - 2)
end

defmodule FibMemoOther do
  import Memoize
   
  defmemo fibs(0), do: "ZERO"
  defmemo fibs(1), do: "A NUMBER ONE"
  defmemo fibs(2), do: "A NUMBER TWO!!"
  defmemo fibs(n), do: "THE NUMBER #{n} IS BORING"
  defmemo fibs(n, x), do: "#{x} AND #{n} /2"
end

defmodule FibMemoWhen do
  import Memoize

  defmemo fibs(n) when is_binary(n), do: {:binary, n}
  defmemo fibs(n) when is_list(n), do: {:list, n}
  defmemo fibs(n, x) when is_list(n) and is_binary(x), do: {n, x}
  defmemo fibs(n), do: {:no_guard, n}
end

defmodule Fib do
@doc ~S"""
"""
  def fibs(0), do: 0
  def fibs(1), do: 1
  def fibs(n), do: fibs(n - 1) + fibs(n - 2)
end
