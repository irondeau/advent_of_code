defmodule AdventOfCodeTest.Y2015.D25Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D25, as: Puzzle

  test "part 1 examples" do
    assert 20151125 = Puzzle.run("row 1, column 1")
    assert 21629792 = Puzzle.run("row 2, column 2")
    assert 1601130 = Puzzle.run("row 3, column 3")
    assert 9380097 = Puzzle.run("row 4, column 4")
    assert 9250759 = Puzzle.run("row 5, column 5")
    assert 27995004 = Puzzle.run("row 6, column 6")
  end

  test "solution" do
    assert 2650453 = Puzzle.run()
  end
end
