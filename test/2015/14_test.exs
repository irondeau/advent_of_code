defmodule AdventOfCodeTest.Y2015.D14Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D14, as: Puzzle

  @reindeer """
Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
"""

  test "examples" do
    assert {2660, 1558} = Puzzle.run(@reindeer)
  end

  test "solution" do
    assert {2655, 1059} = Puzzle.run()
  end
end
