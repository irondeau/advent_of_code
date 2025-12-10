defmodule AdventOfCodeTest.Y2025.D9Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2025.D9, as: Puzzle

  @tiles """
  7,1
  11,1
  11,7
  9,7
  9,5
  2,5
  2,3
  7,3
  """

  test "examples" do
    assert {50, 24} = Puzzle.run(@tiles)
  end

  test "solution" do
    assert {4_748_985_168, 1_550_760_868} = Puzzle.run()
  end
end
