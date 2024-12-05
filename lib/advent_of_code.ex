defmodule AdventOfCode do
  @moduledoc """
  Module which solves `AdventOfCode` problems given a year and day.
  """

  @first_year 2015
  @last_year 2024

  @first_day 1
  @last_day 25

  @type year() :: unquote(@first_year) .. unquote(@last_year)
  @type day() :: unquote(@first_day) .. unquote(@last_day)

  def first_year(), do: @first_year
  def last_year(), do: @last_year

  def first_day(), do: @first_day
  def last_day(), do: @last_day

  @spec solve(year(), day()) :: {any(), any()}
  def solve(year, day) do
    {:ok, Module.concat([AdventOfCode, get_year_module(year), get_day_module(day)]).run()}
  rescue
    # _ in FunctionClauseError -> {:error, :solution_out_of_bounds}
    _ in UndefinedFunctionError -> {:error, :solution_not_found}
  end

  @spec get_year_module(year()) :: String.t()
  defp get_year_module(year) when year >= @first_year and year <= @last_year do
    "Y" <> Integer.to_string(year)
  end

  @spec get_day_module(day()) :: String.t()
  defp get_day_module(day) when day >= 1 and day <= 25 do
    "D" <> Integer.to_string(day)
  end
end
