defmodule AdventOfCode.Helpers.List do
  @moduledoc """
  List helper functions which extend Elixir's standard library.
  """

  def duplicate?(list) when is_list(list) do
    Enum.reduce_while(list, [], fn x, acc ->
      if x in acc, do: {:halt, false}, else: {:cont, [x | acc]}
    end)
    |> is_boolean()
  end
end
