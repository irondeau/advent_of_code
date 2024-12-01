defmodule AdventOfCodeTest.Y2024.D1Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D1, as: Puzzle

  @lists """
3   4
4   3
2   5
1   3
3   9
3   3
"""

  test "examples" do
    assert {11, 31} = Puzzle.run(@lists)
  end

  test "solution" do
    assert {2375403, 23082277} = Puzzle.run()
  end
end
