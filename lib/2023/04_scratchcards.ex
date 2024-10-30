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
    |> Enum.map(fn "Card" <> rest ->
      {id, ": " <> rest} = rest |> String.trim() |> Integer.parse()

      [winning_numbers, numbers] =
        rest
        |> String.split("|")
        |> Enum.map(fn numbers ->
          numbers
          |> String.split()
          |> Enum.map(&String.to_integer/1)
        end)

      %{id: id, winning_numbers: winning_numbers, numbers: numbers}
    end)
  end

  defp solve_1(input) do
    input
    |> Enum.map(fn line ->
      count = Enum.count(line.numbers, &(&1 in line.winning_numbers))
      trunc(2**(count - 1))
    end)
    |> Enum.sum()
  end

  defp solve_2(input) do
    copies = for line <- input, into: %{}, do: {line.id, 1}

    Enum.reduce(input, copies, fn line, copies ->
      count = Enum.count(line.numbers, &(&1 in line.winning_numbers))
      count_copies = Map.get(copies, line.id, 1)

      if count == 0 do
        copies
      else
        Range.new(line.id + 1, line.id + count)
        |> Enum.map(&({&1, count_copies}))
        |> Map.new()
        |> Map.merge(copies, fn _, v1, v2 -> v1 + v2 end)
      end
    end)
    |> Map.filter(fn {id, _} -> id <= length(input) end)
    |> Map.values()
    |> Enum.sum()
  end
end
