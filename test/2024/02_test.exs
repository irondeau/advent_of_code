defmodule AdventOfCodeTest.Y2024.D2Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D2, as: Puzzle

  @reports """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"""

  test "examples" do
    assert {2, 4} = Puzzle.run(@reports)
  end

  test "solution" do
    assert {332, 398} = Puzzle.run()
  end
end
