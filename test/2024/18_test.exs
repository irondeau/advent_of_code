defmodule AdventOfCodeTest.Y2024.D18Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D18, as: Puzzle

  @bytes """
  6 12
  5,4
  4,2
  4,5
  3,0
  2,1
  6,3
  2,4
  1,5
  0,6
  3,3
  2,6
  5,1
  1,2
  5,5
  2,5
  6,5
  1,4
  0,4
  6,4
  1,1
  6,1
  1,0
  0,5
  1,6
  2,0
  """

  test "examples" do
    assert {22, {6, 1}} = Puzzle.run(@bytes)
  end

  test "solution" do
    assert {322, {60, 21}} = Puzzle.run()
  end
end
