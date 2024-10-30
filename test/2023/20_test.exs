defmodule AdventOfCodeTest.Y2023.D20Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y2023.D20, as: Puzzle

  @module_config_1 """
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
"""

  @module_config_2 """
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
"""

  test "part 1 examples" do
    assert {32000000, _} = Puzzle.run(@module_config_1)
    assert {11687500, _} = Puzzle.run(@module_config_2)
  end

  test "solution" do
    assert {898557000, 238420328103151} = Puzzle.run()
  end
end
