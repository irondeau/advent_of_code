defmodule AdventOfCodeTest.Y2025.D11Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2025.D11, as: Puzzle

  @cables """
  aaa: you hhh
  you: bbb ccc
  bbb: ddd eee
  ccc: ddd eee fff
  ddd: ggg
  eee: out
  fff: out
  ggg: out
  hhh: ccc fff iii
  iii: out
  """

  @cables_2 """
  svr: aaa bbb
  aaa: fft
  fft: ccc
  bbb: tty
  tty: ccc
  ccc: ddd eee
  ddd: hub
  hub: fff
  eee: dac
  dac: fff
  fff: ggg hhh
  ggg: out
  hhh: out
  """

  test "part 1 examples" do
    assert {5, _} = Puzzle.run(@cables)
  end

  test "part 2 examples" do
    assert {_, 2} = Puzzle.run(@cables_2)
  end

  test "solution" do
    assert {539, 413_167_078_187_872} = Puzzle.run()
  end
end
