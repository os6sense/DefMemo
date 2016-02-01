ExUnit.start()

defmodule TimedFunction do
  def time(fun) do
    {start, return, stop} = {:os.timestamp, fun.(), :os.timestamp}
    {return, :timer.now_diff(stop, start) }
  end
end

defmodule Fib do
@doc ~S"""
"""
  def fibs(0), do: 0
  def fibs(1), do: 1
  def fibs(n), do: fibs(n - 1) + fibs(n - 2)
end

defmodule FibMemo do
  import DefMemo

  defmemo fibs(0), do: 0
  defmemo fibs(1), do: 1
  defmemo fibs(n), do: fibs(n - 1) + fibs(n - 2)
end

defmodule FibMemoOther do
  import DefMemo

  defmemo fibs(0), do: "ZERO"
  defmemo fibs(1), do: "A NUMBER ONE"
  defmemo fibs(2), do: "A NUMBER TWO!!"
  defmemo fibs(n), do: "THE NUMBER #{n} IS BORING"
  defmemo fibs(n, x), do: "#{x} AND #{n} /2"
end

defmodule TestMemoWhen do
  import DefMemo

  defmemo fibs(n, x) when is_list(n) and is_binary(x), do: {n, x}
  # nb, is binary also covers bitstring
  defmemo fibs(n) when is_binary(n), do: {:binary, n}
  defmemo fibs(n) when is_boolean(n), do: {:boolean, n}
  defmemo fibs(n) when is_atom(n), do: {:atom, n} # nb: atom will match boolean if preceeds it.
  defmemo fibs(n) when is_float(n), do: {:float, n}
  defmemo fibs(n) when is_list(n), do: {:list, n}
  #defmemo fibs(n) when is_integer(n), do: {:integer, n}
  defmemo fibs(n) when is_function(n), do: {:function, n}
  defmemo fibs(n) when is_map(n), do: {:map, n}
  #defmemo fibs(n) when is_number(n), do: {:number, n}
  defmemo fibs(n) when is_pid(n), do: {:pid, n}
  defmemo fibs(n) when is_port(n), do: {:port, n}
  defmemo fibs(n) when is_reference(n), do: {:reference, n}
  defmemo fibs(n) when is_tuple(n), do: {:tuple, n}

  defmemo fibs(n), do: {:no_guard, n}
end

defmodule TestMemoNormalized do
  import DefMemo

  defp normalize_case([x]), do: String.downcase(x)

  defmemo slow_upper(s), normalize_case do
    :timer.sleep(1)     # Could this be why is this code so slow?!
    String.upcase(s)
  end

  defp normalize_many([numbers, multiply_instead]), do: [Enum.sort(numbers), multiply_instead]

  defmemo slow_sum(n, multiply_instead), normalize_many do
    :timer.sleep(1)
    if multiply_instead, do: Enum.reduce(n, fn(x, acc) -> x * acc end), else: Enum.sum(n)
  end

end
