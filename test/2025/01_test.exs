defmodule AdventOfCodeTest.Y2025.D1Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2025.D1, as: Puzzle

  @document """
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
  """

  test "examples" do
    assert {3, 6} = Puzzle.run(@document)
  end

  test "solution" do
    assert {1043, 5963} = Puzzle.run()
  end
end
