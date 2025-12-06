defmodule AdventOfCodeTest.Y2025.D6Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2025.D6, as: Puzzle

  @worksheet """
  123 328  51 64 
   45 64  387 23 
    6 98  215 314
  *   +   *   +  
  """

  test "examples" do
    assert {4_277_556, 3_263_827} = Puzzle.run(@worksheet)
  end

  test "solution" do
    assert {5_346_286_649_122, 10_389_131_401_929} = Puzzle.run()
  end
end
