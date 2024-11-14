defmodule AdventOfCodeTest.Y2015.D13Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D13, as: Puzzle

  @seating_arrangement """
Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol.
"""

  test "examples" do
    assert {330, _} = Puzzle.run(@seating_arrangement)
  end

  @tag :slow
  test "solution" do
    assert {618, 601} = Puzzle.run()
  end
end
