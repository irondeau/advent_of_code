defmodule AdventOfCodeTest.Helpers.PQTest do
  use ExUnit.Case, async: true

  alias AdventOfCode.Helpers.PQ

  test "merge" do
    pq_1 =
      PQ.new()
      |> PQ.push(4)
      |> PQ.push(3)
      |> PQ.push(6)

    assert PQ.merge(pq_1, PQ.new()) == pq_1
    assert PQ.merge(PQ.new(), pq_1) == pq_1
    assert PQ.merge(PQ.new() |> PQ.push(2), pq_1) != pq_1

    pq_2 =
      PQ.new()
      |> PQ.push(1)
      |> PQ.push(2)
      |> PQ.push(5)
      |> PQ.push(7)

    pq = PQ.merge(pq_1, pq_2)

    1..7
    |> Enum.reduce(pq, fn item, pq ->
      {next, pq} = PQ.pop(pq)
      assert next == item
      pq
    end)
    |> then(fn pq -> assert PQ.empty?(pq) end)
  end

  test "insert" do
    pq =
      PQ.new()
      |> PQ.push(2)
      |> PQ.push(3)
      |> PQ.push(1)
      |> PQ.push(4)

    assert PQ.peek(pq) == 1
  end

  test "pop" do
    pq =
      PQ.new()
      |> PQ.push(3)
      |> PQ.push(2)
      |> PQ.push(1)
      |> PQ.push(4)
      |> PQ.push(7)
      |> PQ.push(5)
      |> PQ.push(6)

    1..7
    |> Enum.reduce(pq, fn item, pq ->
      {next, pq} = PQ.pop(pq)
      assert next == item
      pq
    end)
    |> then(fn pq -> assert PQ.empty?(pq) end)
  end

  test "comparator" do
    comparator =
      fn str_1, str_2 ->
        String.to_integer(str_1, 16) > String.to_integer(str_2, 16)
      end

    pq =
      PQ.new(comparator)
      |> PQ.push("990")
      |> PQ.push("51d")
      |> PQ.push("3f3")
      |> PQ.push("ba7")
      |> PQ.push("558")

    ~w(ba7 990 558 51d 3f3)
    |> Enum.reduce(pq, fn item, pq ->
      {next, pq} = PQ.pop(pq)
      assert next == item
      pq
    end)
    |> then(fn pq -> assert PQ.empty?(pq) end)
  end

  test "bad comparator" do
    assert_raise FunctionClauseError, fn ->
      PQ.new(fn _ -> false end)
    end
  end

  test "non-matching comparator functions" do
    comparator =
      fn str_1, str_2 ->
        String.to_integer(str_1, 16) > String.to_integer(str_2, 16)
      end

    pq_1 = PQ.new() |> PQ.push(4)
    pq_2 = PQ.new(comparator) |> PQ.push("990")

    assert_raise ArgumentError, fn ->
      PQ.merge(pq_1, pq_2)
    end
  end
end
