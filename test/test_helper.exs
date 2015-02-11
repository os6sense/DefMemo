ExUnit.start()

defmodule TimedFunction do
@doc ~S"""
"""
  def time(fun) do
    {start, return, stop} = {:erlang.now(), fun.(), :erlang.now()}
    {return, :timer.now_diff(stop, start) }
  end
end

defmodule FibMemo do
@doc ~S"""
"""
  import Memoize
   
  defmemo fibs(0), do: 0
  defmemo fibs(1), do: 1
  defmemo fibs(n), do: fibs(n - 1) + fibs(n - 2)
end

defmodule FibMemoText do
@doc ~S"""
"""
  import Memoize
   
  defmemo fibs(0), do: "ZEERO"
  defmemo fibs(1), do: "A NUMBER ONE"
  defmemo fibs(2), do: "A NUMBER TWO!!"
  defmemo fibs(n), do: "THE NUMBER #{n} IS BORING"
end

defmodule Fib do
@doc ~S"""
"""
  def fibs(0), do: 0
  def fibs(1), do: 1
  def fibs(n), do: fibs(n - 1) + fibs(n - 2)
end
 
