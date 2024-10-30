defmodule AdventOfCodeTest.Y2023.D22Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D22, as: Puzzle

  @bricks """
1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9
"""

  test "examples" do
    assert {5, 7} = Puzzle.run(@bricks)
  end

  test "solution" do
    assert {457, 79122} = Puzzle.run()
  end
end
