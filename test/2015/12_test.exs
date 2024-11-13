defmodule AdventOfCodeTest.Y2015.D12Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D12, as: Puzzle

  test "part 1 examples" do
    assert {6, _} = Puzzle.run("[1,2,3]")
    assert {6, _} = Puzzle.run("{\"a\":2,\"b\":4}")
    assert {3, _} = Puzzle.run("[[[3]]]")
    assert {3, _} = Puzzle.run("{\"a\":{\"b\":4},\"c\":-1}")
    assert {0, _} = Puzzle.run("{\"a\":[-1,1]}")
    assert {0, _} = Puzzle.run("[-1,{\"a\":1}]")
    assert {0, _} = Puzzle.run("[]")
    assert {0, _} = Puzzle.run("{}")
  end

  test "part 2 examples" do
    assert {_, 6} = Puzzle.run("[1,2,3]")
    assert {_, 4} = Puzzle.run("[1,{\"c\":\"red\",\"b\":2},3]")
    assert {_, 0} = Puzzle.run("{\"d\":\"red\",\"e\":[1,2,3,4],\"f\":5}")
    assert {_, 6} = Puzzle.run("[1,\"red\",5]")
  end

  test "solution" do
    assert {191164, 87842} = Puzzle.run()
  end
end
