defmodule AdventOfCode.Helpers.Enum do
  @moduledoc """
  Enumerable helper functions which extend Elixir's standard library.
  """

  def has_dup?(enumerable) do
    Enum.reduce_while(enumerable, [], fn x, acc ->
      if x in acc, do: {:halt, false}, else: {:cont, [x | acc]}
    end)
    |> is_boolean()
  end
end
