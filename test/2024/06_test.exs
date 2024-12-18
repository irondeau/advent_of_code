defmodule AdventOfCodeTest.Y2024.D6Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D6, as: Puzzle

  @guard_map """
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
  """

  test "examples" do
    assert {41, 6} = Puzzle.run(@guard_map)
  end

  @tag :slow
  test "solution" do
    assert {5516, 2008} = Puzzle.run()
  end
end
