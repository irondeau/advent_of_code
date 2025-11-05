defmodule AdventOfCodeTest.Y2022.D4Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2022.D4, as: Puzzle

  @camp """
  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8
  """

  test "examples" do
    assert {2, 4} = Puzzle.run(@camp)
  end

  test "solution" do
    assert {424, 804} = Puzzle.run()
  end
end
