defmodule AdventOfCodeTest.Y2015.D23Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D23, as: Puzzle

  test "solution" do
    assert {255, 334} = Puzzle.run()
  end
end
