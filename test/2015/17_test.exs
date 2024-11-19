defmodule AdventOfCodeTest.Y2015.D17Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D17, as: Puzzle

  test "solution" do
    assert {1304, 18} = Puzzle.run()
  end
end
