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

  test "solution" do
    # something like 4.8478 * 10^14
    # for steps
    #   f(65)           -> 3759
    #   f(65 + 131)     -> 33496
    #   f(65 + 131 * 2) -> 92857
    # gives 606188414811259
    assert {3646, 606188414811259} = Puzzle.run()
  end
end
