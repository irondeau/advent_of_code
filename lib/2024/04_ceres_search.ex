defmodule AdventOfCode.Y2024.D4 do
  use AdventOfCode.Puzzle, year: 2024, day: 4

  @impl true
  def title, do: "Ceres Search"

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
  end

  defp solve_1(xmas_map) do
    for y <- 0..(map_size(xmas_map) - 1),
        x <- 0..(map_size(xmas_map[y]) - 1) do
      count_xmas_1(xmas_map, {x, y})
    end
    |> Enum.sum()
  end

  defp solve_2(xmas_map) do
    for y <- 0..(map_size(xmas_map) - 1),
        x <- 0..(map_size(xmas_map[y]) - 1) do
      count_xmas_2(xmas_map, {x, y})
    end
    |> Enum.sum()
  end

  defp count_xmas_1(xmas_map, {x, y}, [label | rest] \\ ["X", "M", "A", "S"]) do
    if xmas_map[y][x] == label do
      [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}]
      |> Enum.map(fn {dx, dy} ->
        count_xmas_1(xmas_map, {x + dx, y + dy}, rest, {dx, dy})
      end)
      |> Enum.sum()
    else
      0
    end
  end

  defp count_xmas_1(xmas_map, {x, y}, ["S"], _direction) do
    if xmas_map[y][x] == "S", do: 1, else: 0
  end

  defp count_xmas_1(xmas_map, {x, y}, [label | rest], {dx, dy}) do
    with ^label <- xmas_map[y][x] do
      count_xmas_1(xmas_map, {x + dx, y + dy}, rest, {dx, dy})
    else
      _ -> 0
    end
  end

  defp count_xmas_2(xmas_map, {x, y}) do
    if xmas_map[y][x] == "A" do
      [
        [xmas_map[y - 1][x - 1], xmas_map[y + 1][x + 1]],
        [xmas_map[y - 1][x + 1], xmas_map[y + 1][x - 1]]
      ]
      |> Enum.all?(fn diagonal ->
        "M" in diagonal and "S" in diagonal
      end)
      |> if(do: 1, else: 0)
    else
      0
    end
  end
end
