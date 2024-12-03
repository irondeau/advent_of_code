defmodule AdventOfCodeTest.Y2024.D3Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2024.D3, as: Puzzle

  @memory "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  @memory_2 "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

  test "part 1 examples" do
    assert {161, _} = Puzzle.run(@memory)
  end

  test "part 2 examples" do
    assert {_, 48} = Puzzle.run(@memory_2)
  end

  test "solution" do
    assert {165225049, 108830766} = Puzzle.run()
  end
end
