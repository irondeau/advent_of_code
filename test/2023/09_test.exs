defmodule AdventOfCodeTest.Y2023.D9Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D9, as: Puzzle

  @histories """
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
"""

  test "examples" do
    assert {114, 2} = Puzzle.run(@histories)
  end

  test "solution" do
    assert {1993300041, 1038} = Puzzle.run()
  end
end
