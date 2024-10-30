defmodule AdventOfCodeTest.Y2015.D5Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D5, as: Puzzle

  test "part 1 examples" do
    assert {1, _} = Puzzle.run("ugknbfddgicrmopn")
    assert {1, _} = Puzzle.run("aaa")
    assert {0, _} = Puzzle.run("jchzalrnumimnmhp")
    assert {0, _} = Puzzle.run("haegwjzuvuyypxyu")
    assert {0, _} = Puzzle.run("dvszwmarrgswjxmb")
  end
  
  test "part 2 examples" do
    assert {_, 1} = Puzzle.run("qjhvhtzxzqqjkmpb")
    assert {_, 1} = Puzzle.run("xxyxx")
    assert {_, 0} = Puzzle.run("uurcxstgmygtbstg")
    assert {_, 0} = Puzzle.run("ieodomkazucvgmuy")
  end

  test "solution" do
    assert {236, 51} = Puzzle.run()
  end
end
