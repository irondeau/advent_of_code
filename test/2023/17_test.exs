defmodule AdventOfCodeTest.Y2023.D17Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D17, as: Puzzle

  @crucible_map """
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
"""

  test "part 1 examples" do
    # should be 102
    assert {nil, _} = Puzzle.run(@crucible_map)
  end

  test "part 2 examples" do
    assert {_, nil} = Puzzle.run("")
  end

  test "solution" do
    assert {nil, nil} = Puzzle.run()
  end
end
