defmodule AdventOfCodeTest.Y2023.D1Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D1, as: Puzzle

  test "part 1 examples" do
    assert {142, _} =
             Puzzle.run("""
             1abc2
             pqr3stu8vwx
             a1b2c3d4e5f
             treb7uchet
             """)
  end

  test "part 2 examples" do
    assert {_, 281} =
             Puzzle.run("""
             two1nine
             eight2three
             abcone2threexyz
             xtwone3four
             4nineeightseven2
             zoneight234
             7pqrstsixteen
             """)
  end

  test "solution" do
    assert {54601, 54078} = Puzzle.run()
  end
end
