defmodule AdventOfCodeTest.Y2023.D21Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D21, as: Puzzle

  @garden_plot """
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
"""

  test "examples" do
    assert {42, _} = Puzzle.run(@garden_plot)
  end

  @tag :slow
  test "solution" do
    assert {3646, 606188414811259} = Puzzle.run()
  end
end
