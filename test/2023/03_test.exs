defmodule AdventOfCodeTest.Y2023.D3Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D3, as: Puzzle

  @gearbox """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""

  test "examples" do
    assert {4361, 467835} = Puzzle.run(@gearbox)
  end

  test "solution" do
    assert {549908, 81166799} = Puzzle.run()
  end
end
