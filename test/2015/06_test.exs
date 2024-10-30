defmodule AdventOfCodeTest.Y2015.D6Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D6, as: Puzzle

  test "part 1 examples" do
    assert {1000000, _} = Puzzle.run("turn on 0,0 through 999,999")
    assert {1000, _} = Puzzle.run("toggle 0,0 through 999,0")
    assert {0, _} = Puzzle.run("turn off 499,499 through 500,500")
  end
  
  test "part 2 examples" do
    assert {_, 1} = Puzzle.run("turn on 0,0 through 0,0")
    assert {_, 2000000} = Puzzle.run("toggle 0,0 through 999,999")
  end

  @tag :slow
  test "solution" do
    assert {543903, 14687245} = Puzzle.run()
  end
end
