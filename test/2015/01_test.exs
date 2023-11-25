defmodule AdventOfCodeTest.Y2015.D1Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D1, as: Puzzle

  test "part 1 examples" do
    assert {0, _} = Puzzle.run("(())")
    assert {0, _} = Puzzle.run("()()")
    assert {3, _} = Puzzle.run("(((")
    assert {3, _} = Puzzle.run("(()(()(")
    assert {3, _} = Puzzle.run("))(((((")
    assert {-1, _} = Puzzle.run("())")
    assert {-1, _} = Puzzle.run("))(")
    assert {-3, _} = Puzzle.run(")))")
    assert {-3, _} = Puzzle.run(")())())")
  end

  test "part 2 examples" do
    assert {_, 1} = Puzzle.run(")")
    assert {_, 5} = Puzzle.run("()())")
  end

  test "solution" do
    assert {232, 1783} = Puzzle.run()
  end
end
