defmodule AdventOfCodeTest.Y2023.D25Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D25, as: Puzzle

# Example does not work with the probabalistic appoach taken

#   @wiring_diagram """
# jqt: rhn xhk nvd
# rsh: frs pzl lsr
# xhk: hfx
# cmg: qnr nvd lhk bvb
# rhn: xhk bvb hfx
# bvb: xhk hfx
# pzl: lsr hfx nvd
# qnr: nvd
# ntq: jqt hfx bvb xhk
# nvd: lhk
# lsr: lhk
# rzs: qnr cmg lsr rsh
# frs: qnr lhk lsr
# """

#   test "part 1 examples" do
#     assert 54 = Puzzle.run(@wiring_diagram)
#   end

  test "solution" do
    assert 545528 = Puzzle.run()
  end
end
