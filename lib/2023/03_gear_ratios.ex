defmodule AdventOfCode.Y2023.D3 do
  use AdventOfCode.Puzzle, year: 2023, day: 3

  @impl true
  def title, do: "Gear Ratios"

  @impl true
  def solve(input) do
    input
    |> then(&{solve_1(&1), solve_2(&1)})
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      parse_line(line, {0, y, []})
    end)
    |> Map.new()
    |> Map.split_with(fn {_, value} ->
      is_binary(value)
    end)
  end

  defp parse_line("", {_, _, acc}), do: acc
  defp parse_line("." <> rest, {x, y, acc}), do: parse_line(rest, {x + 1, y, acc})

  defp parse_line(<<c>> <> _ = line, {x, y, acc}) when c in ?0..?9 do
    {num, rest} = Integer.parse(line)
    len = floor(:math.log10(num) + 1)
    ref = make_ref()

    parts =
      for i <- 0..(len - 1) do
        {{x + i, y}, {ref, num}}
      end

    parse_line(rest, {x + len, y, acc ++ parts})
  end

  defp parse_line(<<c>> <> rest, {x, y, acc}) do
    parse_line(rest, {x + 1, y, [{{x, y}, <<c>>} | acc]})
  end

  defp solve_1({gears, parts}) do
    neighboring_parts =
      for {coord, _} <- gears,
          neighbor <- neighbors(coord),
          {:ok, part} <- [Map.fetch(parts, neighbor)],
          into: %{},
          do: part

    neighboring_parts
    |> Map.values()
    |> Enum.sum()
  end

  defp solve_2({gears, parts}) do
    for {coord, _} <- gears do
      values = Map.take(parts, neighbors(coord))
        |> Map.values()
        |> Enum.uniq()
        |> Enum.map(&elem(&1, 1))

      if length(values) > 1 do
        Enum.product(values)
      else
        0
      end
    end
    |> Enum.sum()
  end

  defp neighbors({x, y}) do
    for dx <- -1..1, dy <- -1..1, do: {x + dx, y + dy}
  end
end
