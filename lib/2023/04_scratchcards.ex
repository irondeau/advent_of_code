defmodule AdventOfCode.Y2023.D4 do
  use AdventOfCode.Puzzle, year: 2023, day: 4

  @impl true
  def title, do: "Scratchcards"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      Regex.named_captures(~r/Card\s+(?<id>\d+):\s+(?<winning_numbers>.*)\s+\|\s+(?<numbers>.*)/, line)
      |> Enum.map(fn {k, v} -> {String.to_atom(k), parse_numbers(v)} end)
      |> Map.new()
    end)
  end

  defp parse_numbers(numbers) do
    numbers
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> then(fn numbers ->
      if match?([_], numbers) do
        hd(numbers)
      else
        numbers
      end
    end)
  end

  defp solve_1(input) do
    input
    |> Enum.map(fn line ->
      count = Enum.count(line.numbers, &(&1 in line.winning_numbers))
      trunc(:math.pow(2, count - 1))
    end)
    |> Enum.sum()
  end

  defp solve_2(input) do
    input
    |> Enum.reduce({0, []}, fn line, {sum, copies} ->
      count = Enum.count(line.numbers, &(&1 in line.winning_numbers))
      count_copies = Enum.count(copies, &(&1 == line.id))

      if count == 0 do
        {sum + count_copies + 1, copies}
      else
        new_copies =
          Range.new(line.id + 1, line.id + count)
          |> Range.to_list()
          |> List.duplicate(count_copies + 1)
          |> List.flatten()
        {sum + count_copies + 1, new_copies ++ copies}
      end
    end)
    |> elem(0)
  end
end
