defmodule AdventOfCodeTest.Y2015.D16Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D16, as: Puzzle

  test "solution" do
    assert {103, 405} = Puzzle.run()
  end
end
