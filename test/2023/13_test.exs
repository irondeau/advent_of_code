defmodule AdventOfCodeTest.Y2023.D13Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D13, as: Puzzle

  @mirrors """
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
"""

  test "examples" do
    assert {405, 400} = Puzzle.run(@mirrors)
  end

  test "solution" do
    assert {30158, nil} = Puzzle.run()
  end
end
