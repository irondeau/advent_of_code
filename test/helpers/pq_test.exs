defmodule AdventOfCodeTest.Helpers.PQTest do
  use ExUnit.Case, async: true

  alias AdventOfCode.Helpers.PQ

  test "insert" do
    pq =
      PQ.new()
      |> PQ.push("hello", 2)
      |> PQ.push("world", 3)
      |> PQ.push("first", 1)

    assert PQ.peek(pq) == "first"
  end

  test "pop" do
    pq =
      PQ.new()
      |> PQ.push("a", 3)
      |> PQ.push("b", 2)
      |> PQ.push("c", 1)
      |> PQ.push("d", 4)
      |> PQ.push("e", 7)
      |> PQ.push("f", 5)
      |> PQ.push("g", 6)

    ~w(c b a d f g e)
    |> Enum.reduce(pq, fn item, pq ->
      {min, pq} = PQ.pop(pq)
      assert min == item
      pq
    end)
  end
end
