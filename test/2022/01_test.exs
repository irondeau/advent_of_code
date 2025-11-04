defmodule AdventOfCodeTest.Y2022.D1Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2022.D1, as: Puzzle

  @inventories """
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  """

  test "examples" do
    assert {24000, 45000} = Puzzle.run(@inventories)
  end

  test "solution" do
    assert {69836, 207_968} = Puzzle.run()
  end
end
