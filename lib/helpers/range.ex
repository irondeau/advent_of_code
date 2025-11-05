defmodule AdventOfCode.Helpers.Range do
  @moduledoc """
  Range helper functions which extend Elixir's standard library.
  """

  @doc """
  Checks if the first range contains the second.

  Both ranges must be contiguous.
  """
  @spec contains?(Range.t(), Range.t()) :: boolean()
  def contains?(first1..last1//1, first2..last2//1) do
    first1 <= first2 and last1 >= last2
  end
end
