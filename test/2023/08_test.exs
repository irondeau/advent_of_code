defmodule AdventOfCodeTest.Y2023.D8Test do
  use ExUnit.Case, async: true

  @network_1 """
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
"""

  @network_2 """
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
"""

  @network_3 """
LR

11A = (11B, ZZZ)
11B = (ZZZ, 11Z)
11Z = (11B, ZZZ)
AAA = (22B, ZZZ)
22B = (22C, 22C)
22C = (22Z, ZZZ)
22Z = (22B, 22B)
ZZZ = (ZZZ, ZZZ)
"""

  alias AdventOfCode.Y2023.D8, as: Puzzle

  test "part 1 examples" do
    assert {2, _} = Puzzle.run(@network_1)
    assert {6, _} = Puzzle.run(@network_2)
  end

  test "part 2 examples" do
    assert {_, 6} = Puzzle.run(@network_3)
  end

  test "solution" do
    assert {16043, 15726453850399} = Puzzle.run()
  end
end
