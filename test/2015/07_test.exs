defmodule AdventOfCodeTest.Y2015.D7Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D7, as: Puzzle

  @circuit """
123 -> x
456 -> y
x AND y -> d
x OR y -> e
x LSHIFT 2 -> f
y RSHIFT 2 -> g
NOT x -> h
NOT y -> i
"""

  test "part 1 examples" do
    assert {72 , _}   = Puzzle.run(@circuit <> "d -> a")
    assert {507, _}   = Puzzle.run(@circuit <> "e -> a")
    assert {492, _}   = Puzzle.run(@circuit <> "f -> a")
    assert {114, _}   = Puzzle.run(@circuit <> "g -> a")
    assert {65412, _} = Puzzle.run(@circuit <> "h -> a")
    assert {65079, _} = Puzzle.run(@circuit <> "i -> a")
    assert {123, _}   = Puzzle.run(@circuit <> "x -> a")
    assert {456, _}   = Puzzle.run(@circuit <> "y -> a")
  end
  
  test "solution" do
    assert {16076, 2797} = Puzzle.run()
  end
end
