defmodule AdventOfCode.Y2015.D8 do
  use AdventOfCode.Puzzle, year: 2015, day: 8

  @impl true
  def title, do: "Matchsticks"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
  end

  defp solve_1(input) do
    input
    |> Enum.reduce(0, fn line, acc ->
      acc + code_size(line) - memory_size(line)
    end)
  end

  defp solve_2(input) do
    input
    |> Enum.reduce(0, fn line, acc ->
      acc + encode_size(line) - code_size(line)
    end)
  end

  defp code_size(line) do
    String.length(line)
  end

  defp memory_size("\"", acc), do: acc
  defp memory_size("\\x" <> rest, acc), do: String.split_at(rest, 2) |> elem(1) |> memory_size(acc + 1)
  defp memory_size("\\" <> rest, acc), do: String.split_at(rest, 1) |> elem(1) |> memory_size(acc + 1)
  defp memory_size(rest, acc), do: String.split_at(rest, 1) |> elem(1) |> memory_size(acc + 1)
  defp memory_size("\"" <> trimmed), do: memory_size(trimmed, 0)

  defp encode_size(line) do
    line
    |> String.graphemes()
    |> Enum.reduce(2, fn char, acc ->
      case char do
        encodable when encodable in ["\"", "\\"] -> acc + 2
        _ -> acc + 1
      end
    end)
  end
end
