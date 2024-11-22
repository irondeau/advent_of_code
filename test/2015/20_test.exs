defmodule AdventOfCodeTest.Y2015.D20Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D20, as: Puzzle

  @tag :slow
  @tag timeout: 700_000
  test "solution" do
    assert {831600, 884520} = Puzzle.run()
  end
end
