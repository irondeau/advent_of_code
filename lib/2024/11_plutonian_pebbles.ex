defmodule AdventOfCode.Y2024.D11 do
  use AdventOfCode.Puzzle, year: 2024, day: 11
  use Memoize

  require Integer

  @impl true
  def title, do: "Plutonian Pebbles"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  defp solve_1(stones) do
    Enum.map(stones, &blink(&1, 25))
    |> Enum.sum()
  end

  defp solve_2(stones) do
    Enum.map(stones, &blink(&1, 75))
    |> Enum.sum()
  end

  defmemop blink(_stone, 0), do: 1
  defmemop blink(0, count), do: blink(1, count - 1)

  defmemop blink(stone, count) do
    digits = Integer.digits(stone)

    if Integer.is_even(length(digits)) do
      digits
      |> Enum.split(length(digits) |> div(2))
      |> Tuple.to_list()
      |> Enum.map(&Integer.undigits/1)
      |> Enum.map(&blink(&1, count - 1))
      |> Enum.sum()
    else
      blink(stone * 2024, count - 1)
    end
  end
end
