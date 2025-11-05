defmodule AdventOfCodeTest.Y2022.D3Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2022.D3, as: Puzzle

  @rucksacks """
  vJrwpWtwJgWrhcsFMMfFFhFp
  jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
  PmmdzqPrVvPwwTWBwg
  wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
  ttgJtRGJQctTZtZT
  CrZsJsPPZsGzwwsLwLmpwMDw
  """

  test "examples" do
    assert {157, 70} = Puzzle.run(@rucksacks)
  end

  test "solution" do
    assert {7742, 2276} = Puzzle.run()
  end
end
