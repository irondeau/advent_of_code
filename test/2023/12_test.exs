defmodule AdventOfCodeTest.Y2023.D12Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D12, as: Puzzle

  @hot_springs """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"""

  test "examples" do
    assert {21, 525152} = Puzzle.run(@hot_springs)
  end

  @tag :slow
  test "solution" do
    assert {7344, 1088006519007} = Puzzle.run()
  end
end
