defmodule AdventOfCodeTest.Y2015.D22Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D22, as: Puzzle

  test "solution" do
    assert {1269, 1309} = Puzzle.run()
  end
end
