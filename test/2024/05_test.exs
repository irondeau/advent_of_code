defmodule AdventOfCodeTest.Y2024.D5Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D5, as: Puzzle

  @launch_manual """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"""

  test "examples" do
    assert {143, 123} = Puzzle.run(@launch_manual)
  end

  test "solution" do
    assert {4281, 5466} = Puzzle.run()
  end
end
