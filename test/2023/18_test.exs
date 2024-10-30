defmodule AdventOfCodeTest.Y2023.D18Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D18, as: Puzzle

  @dig_plan """
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
"""

  test "examples" do
    assert {62, 952408144115} = Puzzle.run(@dig_plan)
  end

  test "solution" do
    assert {33491, 87716969654406} = Puzzle.run()
  end
end
