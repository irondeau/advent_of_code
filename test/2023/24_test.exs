defmodule AdventOfCodeTest.Y2023.D24Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D24, as: Puzzle

  @hailstones """
7 27
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
"""

  test "examples" do
    assert {2, 47} = Puzzle.run(@hailstones)
  end

  test "solution" do
    assert {25433, nil} = Puzzle.run()
  end
end
