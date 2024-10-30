defmodule AdventOfCodeTest.Y2023.D16Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D16, as: Puzzle

  @mirror_contraption ~S"""
.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
"""

  test "examples" do
    assert {46, 51} = Puzzle.run(@mirror_contraption)
  end

  @tag :slow
  test "solution" do
    assert {6622, 7130} = Puzzle.run()
  end
end
