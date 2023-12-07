defmodule AdventOfCodeTest.Y2023.D7Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D7, as: Puzzle

  @cards """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"""

  @cards_with_joker """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"""

  test "part 1 examples" do
    assert {6440, _} = Puzzle.run(@cards)
  end

  test "part 2 examples" do
    assert {_, 5905} = Puzzle.run(@cards_with_joker)
  end

  test "solution" do
    assert {246912307, 246894760} = Puzzle.run()
  end
end
