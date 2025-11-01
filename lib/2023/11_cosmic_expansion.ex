defmodule AdventOfCode.Y2023.D11 do
  use AdventOfCode.Puzzle, year: 2023, day: 11

  @impl true
  def title, do: "Cosmic Expansion"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    {universe, count} =
      input
      |> String.split(~r/\R/)
      |> Enum.map_reduce(0, fn line, acc ->
        line
        |> String.graphemes()
        |> Enum.map_reduce(acc, fn char, acc ->
          case char do
            "." -> {nil, acc}
            "#" -> {acc, acc + 1}
          end
        end)
      end)

    galaxy_pairs =
      for galaxy_1 <- 0..(count - 2),
          galaxy_2 <- (galaxy_1 + 1)..(count - 1) do
        {galaxy_1, galaxy_2}
      end

    {universe, galaxy_pairs}
  end

  defp solve_1({universe, galaxy_pairs}) do
    universe_map = map_universe(universe)

    galaxy_pairs
    |> Enum.map(fn {galaxy_1, galaxy_2} ->
      {x1, y1} = Map.get(universe_map, galaxy_1)
      {x2, y2} = Map.get(universe_map, galaxy_2)

      abs(y2 - y1) + abs(x2 - x1)
    end)
    |> Enum.sum()
  end

  defp solve_2({universe, galaxy_pairs}) do
    universe_map = map_universe(universe, 1_000_000 - 1)

    galaxy_pairs
    |> Enum.map(fn {galaxy_1, galaxy_2} ->
      {x1, y1} = Map.get(universe_map, galaxy_1)
      {x2, y2} = Map.get(universe_map, galaxy_2)

      abs(y2 - y1) + abs(x2 - x1)
    end)
    |> Enum.sum()
  end

  defp expansion(universe, expand_by) do
    universe
    |> Enum.map(fn row ->
      if not Enum.any?(row), do: expand_by, else: 0
    end)
  end

  defp flip(galaxies) do
    galaxies
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp map_universe(universe, expand_by \\ 1) do
    y_expansion = expansion(universe, expand_by)
    x_expansion = expansion(flip(universe), expand_by)

    y_expansion
    |> Enum.with_index()
    |> Enum.reduce({%{}, 0}, fn {y_factor, y}, {map, y_acc} ->
      if y_factor != 0 do
        {map, y_acc + y_factor}
      else
        {map, _} =
          x_expansion
          |> Enum.with_index()
          |> Enum.reduce({map, 0}, fn {x_factor, x}, {map, x_acc} ->
            if x_factor != 0 do
              {map, x_acc + x_factor}
            else
              galaxy? = universe |> Enum.at(y) |> Enum.at(x)

              if galaxy? do
                {Map.put(map, galaxy?, {x + x_acc, y + y_acc}), x_acc}
              else
                {map, x_acc}
              end
            end
          end)

        {map, y_acc}
      end
    end)
    |> elem(0)
  end
end
