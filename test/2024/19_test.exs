defmodule AdventOfCodeTest.Y2024.D19Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D19, as: Puzzle

  @towel_designs """
  r, wr, b, g, bwu, rb, gb, br

  brwrr
  bggr
  gbbr
  rrbgbr
  ubwu
  bwurrg
  brgr
  bbrgwb
  """

  test "examples" do
    assert {6, 16} = Puzzle.run(@towel_designs)
  end

  test "solution" do
    assert {300, 624802218898092} = Puzzle.run()
  end
end
