defmodule AdventOfCodeTest.Y2024.D14Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D14, as: Puzzle

  @robots """
  11 7
  p=0,4 v=3,-3
  p=6,3 v=-1,-3
  p=10,3 v=-1,2
  p=2,0 v=2,-1
  p=0,0 v=1,3
  p=3,0 v=-2,-2
  p=7,6 v=-1,-3
  p=3,0 v=-1,-2
  p=9,3 v=2,3
  p=7,3 v=-1,2
  p=2,4 v=2,-3
  p=9,5 v=-3,-3
  """

  test "part 1 examples" do
    assert {12, _} = Puzzle.run(@robots)
  end

  test "solution" do
    assert {217132650, 6516} = Puzzle.run()
  end
end
