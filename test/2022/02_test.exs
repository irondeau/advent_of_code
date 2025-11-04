defmodule AdventOfCodeTest.Y2022.D2Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2022.D2, as: Puzzle

  @strategies """
  A Y
  B X
  C Z
  """

  test "examples" do
    assert {15, 12} = Puzzle.run(@strategies)
  end

  test "solution" do
    assert {13675, 14184} = Puzzle.run()
  end
end
