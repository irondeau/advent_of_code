defmodule AdventOfCode.Helpers.Enum do
  def has_dup?(enumerable) do
    Enum.reduce_while(enumerable, [], fn x, acc ->
      if x in acc, do: {:halt, false}, else: {:cont, [x | acc]}
    end)
    |> is_boolean()
  end
end
