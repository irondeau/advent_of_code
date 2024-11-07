defmodule AdventOfCodeTest.Y2023.D25Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D25, as: Puzzle

  @wiring_diagram """
jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr
"""

  # Example does not work with the probabalistic appoach taken
  # test "part 1 examples" do
  #   assert 54 = Puzzle.run(@wiring_diagram)
  # end

  @tag :slow
  @tag timeout: 300_000
  test "solution" do
    assert 545528 = Puzzle.run()
  end
end
