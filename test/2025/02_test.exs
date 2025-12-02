defmodule AdventOfCodeTest.Y2025.D2Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2025.D2, as: Puzzle

  @product_ranges "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

  test "examples" do
    assert {1_227_775_554, 4_174_379_265} = Puzzle.run(@product_ranges)
  end

  test "solution" do
    assert {24_043_483_400, 38_262_920_235} = Puzzle.run()
  end
end
