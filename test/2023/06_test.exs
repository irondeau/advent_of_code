defmodule AdventOfCodeTest.Y2023.D6Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D6, as: Puzzle

  @races """
Time:      7  15   30
Distance:  9  40  200
"""

  @race """
Time:      71530
Distance:  940200
"""

  test "part 1 examples" do
    assert {288, _} = Puzzle.run(@races)
  end

  test "part 2 examples" do
    assert {_, 71503} = Puzzle.run(@race)
  end

  test "solution" do
    assert {2374848, 39132886} = Puzzle.run()
  end
end
