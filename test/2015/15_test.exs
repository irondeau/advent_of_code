defmodule AdventOfCodeTest.Y2015.D15Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D15, as: Puzzle

  @ingredients """
Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
"""

  test "examples" do
    assert {62842880, 57600000} = Puzzle.run(@ingredients)
  end

  @tag :slow
  @tag timeout: 60_000
  test "solution" do
    assert {13882464, 11171160} = Puzzle.run()
  end
end
