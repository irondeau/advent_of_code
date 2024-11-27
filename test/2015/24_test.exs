defmodule AdventOfCodeTest.Y2015.D24Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D24, as: Puzzle

  @packages "1 2 3 4 5 7 8 9 10 11"

  test "examples" do
    assert {99, 44} = Puzzle.run(@packages)
  end

  @tag :slow
  test "solution" do
    assert {11846773891, 80393059} = Puzzle.run()
  end
end
