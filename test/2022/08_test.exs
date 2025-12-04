defmodule AdventOfCodeTest.Y2022.D8Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2022.D8, as: Puzzle

  @forest """
  30373
  25512
  65332
  33549
  35390
  """

  test "examples" do
    assert {21, _} = Puzzle.run(@forest)
  end

  test "solution" do
    assert {1698, nil} = Puzzle.run()
  end
end
