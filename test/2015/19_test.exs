defmodule AdventOfCodeTest.Y2015.D19Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D19, as: Puzzle

  test "solution" do
    assert {518, 200} = Puzzle.run()
  end
end
