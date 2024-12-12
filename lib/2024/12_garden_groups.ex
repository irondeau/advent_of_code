defmodule AdventOfCode.Y2024.D12 do
  use AdventOfCode.Puzzle, year: 2024, day: 12

  @impl true
  def title, do: "Garden Groups"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      {
        y,
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {char, x} -> {x, char} end)
        |> Map.new()
      }
    end)
    |> Map.new()
    |> regionalize()
  end

  defp solve_1(garden) do
    area_map = area(garden)
    perimeter_map = perimeter_1(garden)

    Map.merge(area_map, perimeter_map, fn _k, a, p -> a * p end)
    |> Map.values()
    |> Enum.sum()
  end

  defp solve_2(garden) do
    area_map = area(garden)
    perimeter_map = perimeter_2(garden)

    Map.merge(area_map, perimeter_map, fn _k, a, p -> a * p end)
    |> Map.values()
    |> Enum.sum()
  end

  defp regionalize(garden) do
    for y <- Map.keys(garden),
        x <- Map.keys(garden[y]),
        reduce: garden do
      garden ->
        case garden[y][x] do
          {_label, _ref} -> garden
          _label -> add_region(garden, {x, y}, make_ref())
        end
    end
  end

  defp add_region(garden, {x, y}, ref) do
    label = garden[y][x]
    garden = update_in(garden[y][x], &{&1, ref})

    [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
    |> Enum.reduce(garden, fn {dx, dy}, garden ->
      if garden[y + dy][x + dx] == label do
        add_region(garden, {x + dx, y + dy}, ref)
      else
        garden
      end
    end)
  end

  defp area(garden) do
    garden
    |> Map.values()
    |> Enum.flat_map(&Map.values/1)
    |> Enum.frequencies()
  end

  defp perimeter_1(garden) do
    for y <- Map.keys(garden),
        x <- Map.keys(garden[y]),
        reduce: %{} do
      perimeter_map ->
        [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
        |> Enum.reduce(perimeter_map, fn {dx, dy}, perimeter_map ->
          plot = garden[y][x]

          if garden[y + dy][x + dx] != plot do
            update_in(perimeter_map[plot], fn
              nil -> 1
              n -> n + 1
            end)
          else
            perimeter_map
          end
        end)
    end
  end

  defp perimeter_2(garden) do
    plot_map =
      for y <- Map.keys(garden),
          x <- Map.keys(garden[y]),
          reduce: %{} do
        plot_map ->
          update_in(plot_map, [Access.key(garden[y][x], [])], &[{x, y} | &1])
      end

    for {label, plot} <- plot_map, into: %{} do
      perimeter_count =
        plot
        |> Enum.map(fn {x, y} ->
          [
            [{x - 1, y}, {x - 1, y - 1}, {x, y - 1}], # top left
            [{x, y - 1}, {x + 1, y - 1}, {x + 1, y}], # top right
            [{x + 1, y}, {x + 1, y + 1}, {x, y + 1}], # bottom right
            [{x, y + 1}, {x - 1, y + 1}, {x - 1, y}]  # bottom left
          ]
          |> Enum.count(fn adj ->
            adj
            |> Enum.map(&Enum.member?(plot, &1))
            |> case do
              [false, _, false] -> true     # outer corner
              [true, false, true] -> true   # inner corner
              _ -> false
            end
          end)
        end)
        |> Enum.sum()

      {label, perimeter_count}
    end
  end
end
