defmodule AdventOfCodeTest.Y2015.D10Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D10, as: Puzzle
  
  @tag :slow
  test "solution" do
    assert {492982, 6989950} = Puzzle.run()
  end
end
