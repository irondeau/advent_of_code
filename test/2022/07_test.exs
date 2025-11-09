defmodule AdventOfCodeTest.Y2022.D7Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2022.D7, as: Puzzle

  @terminal """
  $ cd /
  $ ls
  dir a
  14848514 b.txt
  8504156 c.dat
  dir d
  $ cd a
  $ ls
  dir e
  29116 f
  2557 g
  62596 h.lst
  $ cd e
  $ ls
  584 i
  $ cd ..
  $ cd ..
  $ cd d
  $ ls
  4060174 j
  8033020 d.log
  5626152 d.ext
  7214296 k
  """

  test "examples" do
    assert {95437, 24_933_642} = Puzzle.run(@terminal)
  end

  test "solution" do
    assert {1_743_217, 8_319_096} = Puzzle.run()
  end
end
