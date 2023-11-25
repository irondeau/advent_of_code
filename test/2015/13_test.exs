defmodule AdventOfCodeTest.Y2015.D13Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2015.D13, as: Puzzle

  test "part 1 examples" do
    assert {nil, _} = Puzzle.run("")
  end
  
  test "part 2 examples" do
    assert {_, nil} = Puzzle.run("")
  end

  test "solution" do
    assert {nil, nil} = Puzzle.run()
  end
end
