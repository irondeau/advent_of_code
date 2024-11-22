defmodule AdventOfCodeTest.Y2015.D21Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D21, as: Puzzle

  test "solution" do
    assert {91, 158} = Puzzle.run()
  end
end
