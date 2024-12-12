defmodule AdventOfCodeTest.Y2024.D12Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D12, as: Puzzle

  @garden_1 """
  AAAA
  BBCD
  BBCC
  EEEC
  """

  @garden_2 """
  OOOOO
  OXOXO
  OOOOO
  OXOXO
  OOOOO
  """

  @garden_3 """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  """

  @garden_4 """
  EEEEE
  EXXXX
  EEEEE
  EXXXX
  EEEEE
  """

  @garden_5 """
  AAAAAA
  AAABBA
  AAABBA
  ABBAAA
  ABBAAA
  AAAAAA
  """

  test "part 1 examples" do
    assert {140, 80} = Puzzle.run(@garden_1)
    assert {772, 436} = Puzzle.run(@garden_2)
    assert {1930, _} = Puzzle.run(@garden_3)
  end

  test "part 2 examples" do
    assert {_, 236} = Puzzle.run(@garden_4)
    assert {_, 368} = Puzzle.run(@garden_5)
  end

  test "solution" do
    assert {1361494, 830516} = Puzzle.run()
  end
end
