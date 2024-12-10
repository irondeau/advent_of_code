defmodule AdventOfCodeTest.Y2024.D10Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D10, as: Puzzle

  @topographic_map """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """

  test "examples" do
    assert {36, 81} = Puzzle.run(@topographic_map)
  end

  test "solution" do
    assert {746, 1541} = Puzzle.run()
  end
end
