defmodule AdventOfCodeTest.Y2025.D4Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2025.D4, as: Puzzle

  @diagram """
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.
  """

  test "examples" do
    assert {13, 43} = Puzzle.run(@diagram)
  end

  test "solution" do
    assert {1578, 10132} = Puzzle.run()
  end
end
