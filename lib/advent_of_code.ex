defmodule AdventOfCode do
  @moduledoc """
  Module which solves `AdventOfCode` problems given a year and day.
  """

  @first_year 2015

  @spec solve(integer(), integer()) :: {any(), any()}
  def solve(year, day)
      when is_integer(year) and is_integer(day) and year >= @first_year and day >= 1 do
    {:ok, Module.concat([AdventOfCode, "Y#{year}", "D#{day}"]).run()}
  rescue
    _ in UndefinedFunctionError -> {:error, :solution_not_found}
  end
end
