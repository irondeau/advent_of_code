defmodule AdventOfCodeTest.Y2024.D25Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D25, as: Puzzle

  @lock_schematics """
  #####
  .####
  .####
  .####
  .#.#.
  .#...
  .....

  #####
  ##.##
  .#.##
  ...##
  ...#.
  ...#.
  .....

  .....
  #....
  #....
  #...#
  #.#.#
  #.###
  #####

  .....
  .....
  #.#..
  ###..
  ###.#
  ###.#
  #####

  .....
  .....
  .....
  #....
  #.#..
  #.#.#
  #####
  """

  test "examples" do
    assert 3 = Puzzle.run(@lock_schematics)
  end

  test "solution" do
    assert 3397 = Puzzle.run()
  end
end
