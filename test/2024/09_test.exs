defmodule AdventOfCodeTest.Y2024.D9Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D9, as: Puzzle

  @disk_map "2333133121414131402"

  test "examples" do
    assert {1928, 2858} = Puzzle.run(@disk_map)
  end

  test "solution" do
    assert {6337367222422, 6361380647183} = Puzzle.run()
  end
end
