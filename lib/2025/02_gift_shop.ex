defmodule AdventOfCode.Y2025.D2 do
  use AdventOfCode.Puzzle, year: 2025, day: 2

  @impl true
  def title, do: "Gift Shop"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn range ->
      range
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.map(fn {start, stop} -> start..stop end)
    |> Enum.flat_map(&Range.to_list/1)
  end

  defp solve_1(values) do
    values
    |> Enum.map(fn value ->
      if symmetric?(value), do: value, else: 0
    end)
    |> Enum.sum()
  end

  defp solve_2(values) do
    values
    |> Enum.map(fn value ->
      if sequential?(value), do: value, else: 0
    end)
    |> Enum.sum()
  end

  defp symmetric?(value) when is_integer(value) do
    digits = Integer.digits(value)

    middle =
      digits
      |> length()
      |> div(2)

    {first, second} = Enum.split(digits, middle)

    first == second
  end

  defp sequential?(value) do
    digits = Integer.digits(value)
    do_sequential?(digits, length(digits) |> div(2))
  end

  defp do_sequential?(digits, size) do
    if size <= 0 do
      false
    else
      [subvalue | subvalues] = Enum.chunk_every(digits, size)

      if Enum.all?(subvalues, &(&1 == subvalue)),
        do: true,
        else: do_sequential?(digits, size - 1)
    end
  end
end
