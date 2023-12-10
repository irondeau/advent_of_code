defmodule AdventOfCodeTest.Y2023.D10Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D10, as: Puzzle

  @square_loop """
.....
.S-7.
.|.|.
.L-J.
.....
"""

  @complex_loop """
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
"""

  @symmetric_loop """
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
"""

  @scattered_loop """
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
"""

  @grouped_loop """
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
"""

  test "part 1 examples" do
    assert {4, 1} = Puzzle.run(@square_loop)
    assert {8, 1} = Puzzle.run(@complex_loop)
  end

  test "part 2 examples" do
    assert {_, 4} = Puzzle.run(@symmetric_loop)
    assert {_, 8} = Puzzle.run(@scattered_loop)
    assert {_, 10} = Puzzle.run(@grouped_loop)
  end

  @tag :slow
  test "solution" do
    assert {6725, 383} = Puzzle.run()
  end
end
