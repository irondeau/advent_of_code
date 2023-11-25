defmodule Mix.Tasks.Gen do
  @moduledoc """
    Generates source and test files for an Advent of Code puzzle using the given `--year`, `--day`, and `--title` flags"
  """
  @shortdoc "Generate an Advent of Code puzzle"

  @usage "mix gen {--year | -y} year {--day | -d} day {--title | -t} title"

  use Mix.Task
  
  @impl Mix.Task
  def run(args) do
    case Mix.AdventOfCode.parse(args) do
      {[help: true], _, _} -> Mix.shell.info("Usage: #{@usage}")
      {[year: _, day: _, title: _] = assigns, _, _} ->
        assigns = Enum.into(assigns, %{})
        create_puzzle(assigns)
        create_input(assigns)
        create_test(assigns)
      {opts, _, _} ->
        Mix.shell().error("Invald arguments. Got #{opts |> OptionParser.to_argv() |> Enum.join(" ")}; expected --year, --day, and --title flags")
    end
  end
  
  defp create_puzzle(%{year: year, day: day, title: title} = assigns) do
    template = Path.join([
      :code.priv_dir(:advent_of_code),
      "templates",
      "gen",
      "puzzle.eex"
    ])
    path = Path.join([
      File.cwd!(),
      "lib",
      "#{year}",
      String.pad_leading("#{day}", 2, "0") <> "_#{normalize_title(title)}.ex"
    ])
    Mix.Generator.copy_template(template, path, assigns)
  end

  defp create_input(%{year: year, day: day} = _assigns) do
    path = Path.join([
      :code.priv_dir(:advent_of_code),
      "data",
      "inputs",
      "#{year}",
      String.pad_leading("#{day}", 2, "0") <> ".txt"
    ])
    Mix.Generator.create_file(path, "")
  end

  defp create_test(%{year: year, day: day} = assigns) do
    template = Path.join([
      :code.priv_dir(:advent_of_code),
      "templates",
      "gen",
      "test.eex"
    ])
    path = Path.join([
      File.cwd!(),
      "test",
      "#{year}",
      String.pad_leading("#{day}", 2, "0") <> "_test.exs"
    ])
    Mix.Generator.copy_template(template, path, assigns)
  end

  defp normalize_title(title) do
    separators = [32, 45, 95]
    allowlist = separators ++ Enum.to_list(65..90) ++ Enum.to_list(97..122)
    for <<char <- title>>, char in allowlist, into: "" do
      cond do
        char in separators -> "_"
        true -> String.downcase(<<char>>)
      end
    end
  end
end
