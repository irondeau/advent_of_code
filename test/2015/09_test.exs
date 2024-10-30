defmodule AdventOfCodeTest.Y2015.D9Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D9, as: Puzzle

  @distances """
London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141
"""

  test "examples" do
    assert {605, 982} = Puzzle.run(@distances)
  end
  
  test "solution" do
    assert {207, 804} = Puzzle.run()
  end
end
