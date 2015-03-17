defmodule Memoize.Test do
  use ExUnit.Case

  import IO, only: [puts: 1]

  doctest Memoize

  #setup do
    #Memoize.start_link
  #end

  # TODO: Move to benchmark
  #@tag timeout: 100_000
  #test "The Proof Is In The Pudding" do
    #Memoize.start_link
    #puts "\nUNMEMOIZED VS MEMOIZED "
    #puts "***********************"
    #puts "fib (unmemoized)"
    #puts "function -> {result, running time(μs)}"
    #puts "=================================="
    #puts "fibs(30) -> #{inspect TimedFunction.time fn -> Fib.fibs(30) end}"
    #puts "fibs(30) -> #{inspect TimedFunction.time fn -> Fib.fibs(30) end}"

    #puts "\nFibMemo (memoized)"
    #puts "=================================="
    #puts "fibs(30) -> #{inspect TimedFunction.time fn -> FibMemo.fibs(30) end}"
    #puts "fibs(30) -> #{inspect TimedFunction.time fn -> FibMemo.fibs(30) end}"
    #puts "fibs(50) -> #{inspect TimedFunction.time fn -> FibMemo.fibs(50) end}" 
    #puts "fibs(50) -> #{inspect TimedFunction.time fn -> FibMemo.fibs(50) end}" 
  #end

  test "identical function signatures in different modules return the correct result" do
    Memoize.start_link

    FibMemo.fibs(20)
    FibMemoOther.fibs(20)

    assert FibMemo.fibs(20) == 6765
    assert FibMemoOther.fibs(20) == "THE NUMBER 20 IS BORING"
  end

  test "identical function names with different aritys return the correct result" do
    Memoize.start_link

    FibMemoOther.fibs(20)
    FibMemoOther.fibs(20, 21)

    assert FibMemoOther.fibs(20) == "THE NUMBER 20 IS BORING"
    assert FibMemoOther.fibs(20, 21) == "21 AND 20 /2"
  end

  test "identical function names when guard conditions correct result" do
    Memoize.start_link

    FibMemoWhen.fibs(20)
    FibMemoWhen.fibs("20")
    FibMemoWhen.fibs([1, 2, 3])

    assert FibMemoWhen.fibs(20) == {:no_guard, 20}
    assert FibMemoWhen.fibs("20") == {:binary, "20"}
    assert FibMemoWhen.fibs([1, 2, 3]) == {:list, [1, 2, 3]}
  end

  test "#Memoize.ResultTable.get returns {:miss, nil} for unmemo'd result" do
    Memoize.start_link
    assert Memoize.ResultTable.GS.get(:"Elixir.FibMemo.fibs", [20]) == {:miss, nil}
  end

  test "#Memoize.ResultTable.get returns {:hit, result} for a memo'd result" do
    Memoize.start_link
    FibMemo.fibs(20)
    assert {:hit, 6765} == Memoize.ResultTable.GS.get(:"Elixir.FibMemo.fibs", [20]) 
  end


  test "#Memoize.ResultTable.get returns correctly when is_binary" do
    Memoize.start_link

    f_n = "Elixir.FibMemoWhen.when [fibs(n),"
    FibMemoWhen.fibs("20")
    assert Memoize.ResultTable.GS.get(:"#{f_n} is_binary(n)]", ["20"]) == {:hit, {:binary, "20"} } 
  end


  test "#Memoize.ResultTable.get returns correctly when is_list" do
    Memoize.start_link

    FibMemoWhen.fibs([1, 2, 3])
    assert Memoize.ResultTable.GS.get(:"Elixir.FibMemoWhen.when [fibs(n), is_list(n)]", [[1, 2, 3]]) == {:hit, {:list, [1, 2, 3]} } 
  end
    

  test "#Memoize.ResultTable.get returns correctly when is_list and is_binary" do
    Memoize.start_link
    FibMemoWhen.fibs([1, 2, 3], "TEST")
    assert Memoize.ResultTable.GS.get(:"Elixir.FibMemoWhen.when [fibs(n, x), is_list(n) and is_binary(x)]", [[1, 2, 3], "TEST"]) == {:hit, {[1, 2, 3], "TEST"} } 
  end



end

