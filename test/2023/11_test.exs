defmodule AdventOfCodeTest.Y2023.D11Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D11, as: Puzzle

  @galaxies """
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
"""

  test "examples" do
    assert {374, 82000210} = Puzzle.run(@galaxies)
  end

  test "solution" do
    assert {9605127, 458191688761} = Puzzle.run()
  end
end
