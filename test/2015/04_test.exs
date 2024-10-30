defmodule AdventOfCodeTest.Y2015.D4Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D4, as: Puzzle

  @tag :slow
  test "part 1 examples" do
    assert {609043, _} = Puzzle.run("abcdef")
    assert {1048970, _} = Puzzle.run("pqrstuv")
  end

  @tag :slow
  test "solution" do
    assert {282749, 9962624} = Puzzle.run()
  end
end
