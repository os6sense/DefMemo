defmodule MemoizeTest do
  use ExUnit.Case

  import IO, only: [puts: 1]

  doctest Memoize

  test "The Proof Is In The Pudding" do
    Memoize.start_link

    puts "\nUNMEMOIZED VS MEMOIZED "
    puts "fib"
    puts "function -> {result, running time(μs)}"
    puts "=================================="
    puts "fibs(30) -> #{inspect TimedFunction.time fn -> Fib.fibs(30) end}"
    puts "fibs(30) -> #{inspect TimedFunction.time fn -> Fib.fibs(30) end}"

    puts "\nFibMemo"
    puts "=================================="
    puts "fibs(30) -> #{inspect TimedFunction.time fn -> FibMemo.fibs(30) end}"
    puts "fibs(30) -> #{inspect TimedFunction.time fn -> FibMemo.fibs(30) end}"
    puts "fibs(50) -> #{inspect TimedFunction.time fn -> FibMemo.fibs(50) end}" 
    puts "fibs(50) -> #{inspect TimedFunction.time fn -> FibMemo.fibs(50) end}" 
  end

  test "identical function signatures in different modules return the correct result" do
    Memoize.start_link

    FibMemo.fibs(20)
    FibMemoText.fibs(20)

    assert FibMemo.fibs(20) == 6765
    assert FibMemoText.fibs(20) == "THE NUMBER 20 IS BORING"
  end
end

defmodule Memoize.ResultTableTest do
  use ExUnit.Case
  test "#Memoize.ResultTable.get returns {:miss, nil} for unmemo'd result" do
    Memoize.start_link
    assert Memoize.ResultTable.get(:"Elixir.FibMemo.fibs", [20]) == {:miss, nil}
  end

  test "#Memoize.ResultTable.get returns {:hit, result} for a memod result" do
    Memoize.start_link
    FibMemo.fibs(20)
    assert {:hit, 6765} == Memoize.ResultTable.get(:"Elixir.FibMemo.fibs", [20]) 
  end


end

