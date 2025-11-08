defmodule AdventOfCodeTest.Y2022.D6Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2022.D6, as: Puzzle

  test "examples" do
    assert {7, 19} = Puzzle.run("mjqjpqmgbljsphdztnvjfqwrcgsmlb")
    assert {5, 23} = Puzzle.run("bvwbjplbgvbhsrlpgdmjqwftvncz")
    assert {6, 23} = Puzzle.run("nppdvjthqldpwncqszvftbrmjlhg")
    assert {10, 29} = Puzzle.run("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
    assert {11, 26} = Puzzle.run("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
  end

  test "solution" do
    assert {1566, 2265} = Puzzle.run()
  end
end
