defmodule AdventOfCode.Y2024.D16 do
  use AdventOfCode.Puzzle, year: 2024, day: 16

  alias AdventOfCode.Helpers.PQ

  defmodule Tile do
    @moduledoc """
    A data structure used to pathfind through the reindeer maze used by the priority queue in
    Djikstra's algorithm.
    """

    @enforce_keys [:position, :direction]
    defstruct [:position, :direction, weight: 0, visited: []]
  end

  @impl true
  def title, do: "Reindeer Maze"

  @impl true
  def solve(maze) do
    start = Enum.find_value(maze, fn {key, value} -> if value == "S", do: key end)
    stop = Enum.find_value(maze, fn {key, value} -> if value == "E", do: key end)
    maze = MapSet.new(Map.keys(maze))

    tile_queue =
      PQ.new(fn %Tile{weight: w1}, %Tile{weight: w2} -> w1 < w2 end)
      |> PQ.push(%Tile{position: start, direction: :right, visited: [start]})

    {tile, tile_queue} = pathfind(maze, tile_queue, stop)

    {tile.weight, solve_2(tile_queue, tile)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reject(fn {char, _x} -> char == "#" end)
      |> Enum.map(fn {char, x} -> {{x, y}, char} end)
    end)
    |> Map.new()
  end

  defp solve_2(tile_queue, tile) do
    get_shortest_paths(tile_queue, tile.position, tile.weight, [tile.visited])
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end

  defp pathfind(maze, tile_queue, stop, cache \\ %{}) do
    with {tile, tile_queue} <- PQ.pop(tile_queue) do
      if tile.position == stop do
        {tile, tile_queue}
      else
        {x, y} = tile.position

        tile_queue =
          [
            %Tile{position: {x - 1, y}, direction: :left},
            %Tile{position: {x + 1, y}, direction: :right},
            %Tile{position: {x, y - 1}, direction: :up},
            %Tile{position: {x, y + 1}, direction: :down}
          ]
          |> Enum.map(fn next_tile ->
            %{
              next_tile
              | weight: tile.weight + if(next_tile.direction == tile.direction, do: 1, else: 1001),
                visited: [next_tile.position | tile.visited]
            }
          end)
          |> Enum.filter(fn next_tile ->
            MapSet.member?(maze, next_tile.position) and
              next_tile.weight <
                Map.get(cache, {next_tile.position, next_tile.direction}, :infinity)
          end)
          |> Enum.reduce(tile_queue, fn next_tile, tile_queue ->
            PQ.push(tile_queue, next_tile)
          end)

        cache = Map.put(cache, {tile.position, tile.direction}, tile.weight)

        pathfind(maze, tile_queue, stop, cache)
      end
    end
  end

  defp get_shortest_paths(tile_queue, stop, weight, acc) do
    {tile, tile_queue} = PQ.pop(tile_queue)

    case tile do
      %Tile{position: ^stop, weight: ^weight, visited: visited} ->
        get_shortest_paths(tile_queue, stop, weight, [visited | acc])

      %Tile{weight: ^weight} ->
        get_shortest_paths(tile_queue, stop, weight, acc)

      _ ->
        acc
    end
  end
end
