defmodule AdventOfCodeTest.Y2015.D8Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D8, as: Puzzle

  @input ~S"""
""
"abc"
"aaa\"aaa"
"\x27"
"""

  test "part 1 examples" do
    assert {12, _} = Puzzle.run(@input)
  end
  
  test "part 2 examples" do
    assert {_, 19} = Puzzle.run(@input)
  end

  test "solution" do
    assert {1371, 2117} = Puzzle.run()
  end
end
