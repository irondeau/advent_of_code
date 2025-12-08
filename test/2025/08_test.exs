defmodule AdventOfCodeTest.Y2025.D8Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2025.D8, as: Puzzle

  @junction_boxes """
  10
  162,817,812
  57,618,57
  906,360,560
  592,479,940
  352,342,300
  466,668,158
  542,29,236
  431,825,988
  739,650,466
  52,470,668
  216,146,977
  819,987,18
  117,168,530
  805,96,715
  346,949,466
  970,615,88
  941,993,340
  862,61,35
  984,92,344
  425,690,689
  """

  test "examples" do
    assert {40, 25272} = Puzzle.run(@junction_boxes)
  end

  @tag :slow
  test "solution" do
    assert {75582, 59_039_696} = Puzzle.run()
  end
end
