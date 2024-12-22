defmodule AdventOfCodeTest.Y2024.D22Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D22, as: Puzzle

  @secret_numbers_1 """
  1
  10
  100
  2024
  """

  @secret_numbers_2 """
  1
  2
  3
  2024
  """

  test "part 1 examples" do
    assert {37327623, _} = Puzzle.run(@secret_numbers_1)
  end

  test "part 2 examples" do
    assert {_, 23} = Puzzle.run(@secret_numbers_2)
  end

  @tag :slow
  test "solution" do
    assert {17163502021, 1938} = Puzzle.run()
  end
end
