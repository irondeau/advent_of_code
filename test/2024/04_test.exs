defmodule AdventOfCodeTest.Y2024.D4Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D4, as: Puzzle

  @xmas_map """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"""

  test "part 1 examples" do
    assert {18, 9} = Puzzle.run(@xmas_map)
  end

  test "solution" do
    assert {2536, 1875} = Puzzle.run()
  end
end
