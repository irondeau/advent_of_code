defmodule AdventOfCodeTest.Y2025.D5Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2025.D5, as: Puzzle

  @inventory """
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32
  """

  test "examples" do
    assert {3, 14} = Puzzle.run(@inventory)
  end

  test "solution" do
    assert {577, 350_513_176_552_950} = Puzzle.run()
  end
end
