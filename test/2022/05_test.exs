defmodule AdventOfCodeTest.Y2022.D5Test do
  use ExUnit.Case, async: true

  @ship """
      [D]    
  [N] [C]    
  [Z] [M] [P]
   1   2   3 

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2
  """

  alias AdventOfCode.Y2022.D5, as: Puzzle

  test "examples" do
    assert {"CMZ", "MCD"} = Puzzle.run(@ship)
  end

  test "solution" do
    assert {"MQSHJMWNH", "LLWJRBHVZ"} = Puzzle.run()
  end
end
