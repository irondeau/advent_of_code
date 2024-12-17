defmodule AdventOfCodeTest.Y2024.D17Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D17, as: Puzzle

  @program_1 """
  Register A: 729
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0
  """

  @program_2 """
  Register A: 2024
  Register B: 0
  Register C: 0

  Program: 0,3,5,4,3,0
  """

  test "part 1 examples" do
    assert "4,6,3,5,6,3,5,2,1,0" =
      @program_1
      |> String.trim()
      |> Puzzle.parse()
      |> Puzzle.solve_1()
  end

  test "part 2 examples" do
    assert {_, 117440} = Puzzle.run(@program_2)
  end

  test "solution" do
    assert {"7,1,2,3,2,6,7,2,5", 202356708354602} = Puzzle.run()
  end
end
