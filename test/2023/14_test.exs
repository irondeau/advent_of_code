defmodule AdventOfCodeTest.Y2023.D14Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D14, as: Puzzle

  @rocks """
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
"""

  test "part 1 examples" do
    assert {136, 64} = Puzzle.run(@rocks)
  end

  test "solution" do
    assert {107142, 104815} = Puzzle.run()
  end
end
