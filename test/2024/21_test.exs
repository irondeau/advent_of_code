defmodule AdventOfCodeTest.Y2024.D21Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D21, as: Puzzle

  @key_codes """
  029A
  980A
  179A
  456A
  379A
  """

  test "part 1 examples" do
    assert {126384, _} = Puzzle.run(@key_codes)
  end

  test "solution" do
    assert {197560, 242337182910752} = Puzzle.run()
  end
end
