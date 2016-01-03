defmodule DefMemo.Test do
  use ExUnit.Case

  import IO, only: [puts: 1]

  @tag timeout: 100_000
  test "The Proof Is In The Pudding" do
    puts "\nUNMEMOIZED VS MEMOIZED "
    puts "***********************"
    puts "fib (unmemoized)"
    puts "function -> {result, running time(μs)}"
    puts "=================================="
    puts "fibs(30) -> #{inspect TimedFunction.time fn -> Fib.fibs(30) end}"
    puts "fibs(30) -> #{inspect TimedFunction.time fn -> Fib.fibs(30) end}"

    puts "\nFibMemo (memoized)"
    puts "=================================="
    puts "fibs(30) -> #{inspect TimedFunction.time fn -> FibMemo.fibs(30) end}"
    puts "fibs(30) -> #{inspect TimedFunction.time fn -> FibMemo.fibs(30) end}"
    puts "fibs(50) -> #{inspect TimedFunction.time fn -> FibMemo.fibs(50) end}"
    puts "fibs(50) -> #{inspect TimedFunction.time fn -> FibMemo.fibs(50) end}"
  end

  test "identical function signatures in different modules return correct results" do
    FibMemo.fibs(20)
    FibMemoOther.fibs(20)

    assert FibMemo.fibs(20) == 6765
    assert FibMemoOther.fibs(20) == "THE NUMBER 20 IS BORING"
  end

  test "identical function names with different arities return correct results" do
    FibMemo.fibs(20)
    FibMemoOther.fibs(20)
    FibMemoOther.fibs(20, 21)

    assert FibMemo.fibs(20) == 6765
    assert FibMemoOther.fibs(20) == "THE NUMBER 20 IS BORING"
    assert FibMemoOther.fibs(20, 21) == "21 AND 20 /2"
  end

  test "identical function names with guard conditions return correct results" do
    TestMemoWhen.fibs(20)
    TestMemoWhen.fibs("20")
    TestMemoWhen.fibs([1, 2, 3])

    assert TestMemoWhen.fibs(20) == {:no_guard, 20}
    assert TestMemoWhen.fibs("20") == {:binary, "20"}
    assert TestMemoWhen.fibs([1, 2, 3]) == {:list, [1, 2, 3]}
  end
end
