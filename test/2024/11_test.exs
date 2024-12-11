defmodule AdventOfCodeTest.Y2024.D11Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D11, as: Puzzle

  @stones "125 17"

  test "examples" do
    assert {55312, _} = Puzzle.run(@stones)
  end

  test "solution" do
    assert {190865, 225404711855335} = Puzzle.run()
  end
end
