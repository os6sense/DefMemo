
defmodule DefMemo.ResultTable.GS.Test do
  use ExUnit.Case
  """
    Direct tests of the GenServer ResultTable.
  """
  alias DefMemo.ResultTable.GS, as: RT

  @fstr "Elixir.TestMemoWhen.when [fibs(n),"

  # === Basic Tests
  test "returns {:miss, nil} for unmemoed result" do
    assert RT.get(:"Elixir.FibMemo.fibs", [100]) == {:miss, nil}
  end

  test "returns {:hit, result} for a memo'd result" do
    FibMemo.fibs(20)
    assert RT.get(:"Elixir.FibMemo.fibs", [20])  == {:hit, 6765} 
  end

  # Drying up the tests
  defp do_is_test(is_name, atom,  test_value) do
    TestMemoWhen.fibs(test_value)
    assert RT.get(:"#{@fstr} #{is_name}(n)]", [test_value]) == {:hit, {atom, test_value} } 
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
    {:hit, {:function, fnc}} = RT.get(:"#{@fstr} is_function(n)]", [test_value] ) 
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
    assert RT.get(:"Elixir.TestMemoWhen.when [fibs(n, x), is_list(n) and is_binary(x)]", [[1, 2, 3], "TEST"]) == {:hit, {[1, 2, 3], "TEST"} } 
  end
end
