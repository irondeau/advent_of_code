defmodule AdventOfCodeTest.Y2024.D23Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D23, as: Puzzle

  @network """
  kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
"""

  test "examples" do
    assert {7, "co,de,ka,ta"} = Puzzle.run(@network)
  end

  test "solution" do
    assert {1306, "bd,dk,ir,ko,lk,nn,ob,pt,te,tl,uh,wj,yl"} = Puzzle.run()
  end
end
