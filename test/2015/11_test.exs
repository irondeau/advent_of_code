defmodule AdventOfCodeTest.Y2015.D11Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D11, as: Puzzle

  @tag :slow
  test "part 1 examples" do
    assert {"abcdffaa", _} = Puzzle.run("abcdefgh")
    assert {"ghjaabcc", _} = Puzzle.run("ghijklmn")
  end

  test "solution" do
    assert {"cqjxxyzz", "cqkaabcc"} = Puzzle.run()
  end
end
