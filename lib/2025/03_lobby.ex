defmodule AdventOfCode.Y2025.D3 do
  use AdventOfCode.Puzzle, year: 2025, day: 3

  @impl true
  def title, do: "Lobby"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.trim()
    |> String.split(~r/\R/)
    |> Enum.map(fn bank ->
      bank
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp solve_1(banks) do
    Enum.sum_by(banks, fn bank ->
      joltage(bank, 2)
    end)
  end

  defp solve_2(banks) do
    Enum.sum_by(banks, &joltage/1)
  end

  defp joltage(bank, size \\ 12, acc \\ [])

  defp joltage(_bank, 0, acc) do
    acc
    |> Enum.reverse()
    |> Integer.undigits()
  end

  defp joltage(bank, size, acc) do
    {next_digit, next_index} =
      bank
      |> Enum.with_index()
      |> Enum.slice(0..-size//1)
      |> Enum.max_by(&elem(&1, 0))

    rest = Enum.slice(bank, (next_index + 1)..-1//1)

    joltage(rest, size - 1, [next_digit | acc])
  end
end
