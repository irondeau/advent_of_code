defmodule AdventOfCodeTest.Y2024.D20Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D20, as: Puzzle

  @tag :slow
  test "solution" do
    assert {1346, 985482} = Puzzle.run()
  end
end
