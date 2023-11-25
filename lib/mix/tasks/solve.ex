defmodule Mix.Tasks.Solve do
  @moduledoc """
    Solve the Advent of Code puzzle using the given `--year` and `--day` flags"
  """
  @shortdoc "Solve an Advent of Code puzzle"

  @usage "mix solve {--year | -y} year {--day | -d} day"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    case Mix.AdventOfCode.parse(args) do
      {[help: true], _, _} -> Mix.shell.info("Usage: #{@usage}")
      {[year: year, day: day], _, _} -> 
        case AdventOfCode.solve(year, day) do
          {:ok, {result_pt_1, result_pt_2}} ->
            Mix.shell().info("Result:\n\s\sPart 1: #{result_pt_1}\n\s\sPart 2: #{result_pt_2}")
          {:ok, result} ->
            Mix.shell().info("Result: #{result}")
          {:error, :solution_out_of_bounds} ->
            Mix.shell().error("Invalid date #{day}/#{year}. Date must match "
              <> "#{AdventOfCode.first_year()} <= year <= #{AdventOfCode.last_year()} and "
              <> "#{AdventOfCode.first_day()} <= day <= #{AdventOfCode.last_day}")
          {:error, :solution_not_found} ->
            Mix.shell().info("Solution for puzzle #{day}/#{year} has not yet been implemented")
        end
      {opts, _, _} ->
        Mix.shell().error("Invald arguments. Got #{opts |> OptionParser.to_argv() |> Enum.join(" ")}; expected both --year and --day")
    end
  end
end
