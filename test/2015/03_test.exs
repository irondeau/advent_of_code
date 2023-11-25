defmodule AdventOfCodeTest.Y2015.D3Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D3, as: Puzzle

  test "part 1 examples" do
    assert {2, _} = Puzzle.run(">")
    assert {4, _} = Puzzle.run("^>v<")
    assert {2, _} = Puzzle.run("^v^v^v^v^v")
  end

  test "part 2 examples" do
    assert {_, 3} = Puzzle.run("^v")
    assert {_, 3} = Puzzle.run("^>v<")
    assert {_, 11} = Puzzle.run("^v^v^v^v^v")
  end

  test "solution" do
    assert {2592, 2360} = Puzzle.run()
  end
end
