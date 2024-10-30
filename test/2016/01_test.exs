defmodule AdventOfCodeTest.Y2016.D1Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2016.D1, as: Puzzle

  test "part 1 examples" do
    assert {nil, _} = Puzzle.solve("")
  end
  
  test "part 2 examples" do
    assert {_, nil} = Puzzle.solve("")
  end

  test "solution" do
    assert {nil, nil} = Puzzle.run()
  end
end
