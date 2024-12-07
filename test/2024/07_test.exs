defmodule AdventOfCodeTest.Y2024.D7Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D7, as: Puzzle

  @calibration_equations """
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
  """

  test "examples" do
    assert {3749, 11387} = Puzzle.run(@calibration_equations)
  end

  test "solution" do
    assert {21572148763543, 581941094529163} = Puzzle.run()
  end
end
