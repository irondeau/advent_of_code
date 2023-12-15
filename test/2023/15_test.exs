defmodule AdventOfCodeTest.Y2023.D15Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D15, as: Puzzle

  @sequence "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

  test "examples" do
    assert {1320, 145} = Puzzle.run(@sequence)
  end

  test "solution" do
    assert {505459, 228508} = Puzzle.run()
  end
end
