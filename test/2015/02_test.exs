defmodule AdventOfCodeTest.Y2015.D2Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D2, as: Puzzle

  test "examples" do
    assert {58, 34} = Puzzle.run("2x3x4")
    assert {43, 14} = Puzzle.run("1x1x10")
  end

  test "solution" do
    assert {1606483, 3842356} = Puzzle.run()
  end
end
