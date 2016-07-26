
defmodule DefMemo.ResultTable.GS.Test do
  use ExUnit.Case
  @doc """
    Direct tests of the GenServer ResultTable.
  """
  alias DefMemo.ResultTable.GS, as: RT

  @fstr {:"Elixir.TestMemoWhen", :fibs}

  @fib_memo {:"Elixir.FibMemo", :fibs}

  # === Basic Tests
  test "returns {:miss, nil} for unmemoed result" do
    assert RT.get(@fib_memo, [100]) == {:miss, nil}
  end

  test "returns {:hit, result} for a memo'd result" do
    FibMemo.fibs(20)
    assert RT.get(@fib_memo, [20])  == {:hit, 6765}
  end

  test "delete removes a memo'd result" do
    RT.delete(@fib_memo, [10])
    assert RT.get(@fib_memo, [10]) == {:miss, nil}
    FibMemo.fibs(10)
    assert RT.get(@fib_memo, [10]) == {:hit, 55}
    RT.delete(@fib_memo, [10])
    assert RT.get(@fib_memo, [10]) == {:miss, nil}
  end

  # Drying up the tests
  defp do_is_test(is_name, atom,  test_value) do
    TestMemoWhen.fibs(test_value)
    assert RT.get(@fstr, [test_value]) == {:hit, {atom, test_value} }, is_name
  end

  test "returns correct result when is_binary" do
    do_is_test("is_binary", :binary, "20")
  end

  test "returns correctly when is_list" do
    do_is_test("is_list", :list, [1, 2, 3])
  end

  test "returns correctly when is_atom" do
    do_is_test("is_atom", :atom, :test)
  end

  test "returns correctly when is_bitstring (caught by is_binary)" do
    do_is_test("is_binary", :binary, <<1, 0, 0, 0, 0, 0, 0, 0, 0>>)
  end

  test "returns correctly when is_boolean" do
    do_is_test("is_boolean", :boolean, true)
  end

  test "returns correctly when is_float" do
    do_is_test("is_float", :float, 3.14159265359)
  end

  test "returns correctly when is_function" do
    do_is_test("is_function", :function, fn(a) -> a * 2 end)
  end

  test "functions can be memoized!" do
    test_value = fn(a) -> a * 2 end
    do_is_test("is_function", :function, test_value)
    {:hit, {:function, fnc}} = RT.get(@fstr, [test_value] )
    # functions can be memoized!? Useful if the key isnt the function itself...
    assert fnc.(2) == 4
  end

  test "returns correctly when is_map" do
    do_is_test("is_map", :map, %{:a => 1, :b => 2})
  end

  test "returns correctly when is_pid" do
    do_is_test("is_pid", :pid, self)
  end

  test "returns correctly when is_port" do
  end

  test "returns correctly when is_reference" do
  end

  test "returns correctly when is_tuple" do
    do_is_test("is_tuple", :tuple, {1,2,3})
  end

  test "#DefMemo.ResultTable.get returns correctly when is_list and is_binary" do
    TestMemoWhen.fibs([1, 2, 3], "TEST")
    assert RT.get(@fstr, [[1, 2, 3], "TEST"]) == {:hit, {[1, 2, 3], "TEST"} }
  end
end
