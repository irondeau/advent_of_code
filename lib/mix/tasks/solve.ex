defmodule Mix.Tasks.Solve do
  @moduledoc """
    Solve the Advent of Code puzzle using the given `--year` and `--day` flags
  """
  @shortdoc "Solve an Advent of Code puzzle"

  @usage "mix solve {--year | -y} year {--day | -d} day"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {:ok, _} = Application.ensure_all_started(:memoize)

    case Mix.AdventOfCode.parse(args) do
      {[help: true], _, _} ->
        Mix.shell().info("Usage: #{@usage}")

      {[year: year, day: day], _, _} ->
        case AdventOfCode.solve(year, day) do
          {:ok, {result_pt_1, result_pt_2}} ->
            Mix.shell().info("""
            Result:
              Part 1: #{result_pt_1}
              Part 2: #{result_pt_2}
            """)

          {:ok, result} ->
            Mix.shell().info("Result: #{result}")

          {:error, :solution_not_found} ->
            Mix.shell().info("Solution for puzzle #{day}/#{year} has not yet been implemented")
        end

      {opts, _, _} ->
        Mix.shell().error(
          "Invald arguments. Got #{opts |> OptionParser.to_argv() |> Enum.join(" ")}; expected both --year and --day"
        )
    end
  end
end
