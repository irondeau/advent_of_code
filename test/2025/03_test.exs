defmodule AdventOfCodeTest.Y2025.D3Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2025.D3, as: Puzzle

  @banks """
  987654321111111
  811111111111119
  234234234234278
  818181911112111
  """

  test "examples" do
    assert {357, 3_121_910_778_619} = Puzzle.run(@banks)
  end

  test "solution" do
    assert {17107, 169_349_762_274_117} = Puzzle.run()
  end
end
