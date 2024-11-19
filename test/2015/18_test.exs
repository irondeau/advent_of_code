defmodule AdventOfCodeTest.Y2015.D18Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D18, as: Puzzle

  test "solution" do
    assert {821, 886} = Puzzle.run()
  end
end
