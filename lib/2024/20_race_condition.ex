defmodule AdventOfCode.Y2024.D20 do
  use AdventOfCode.Puzzle, year: 2024, day: 20

  alias AdventOfCode.Helpers.Digraph

  @timesave 100

  @impl true
  def title, do: "Race Condition"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    racetrack = :digraph.new()

    # add vertices
    input
    |> String.split(~r/\R/)
    |> Enum.with_index()
    |> Enum.each(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.each(fn
        {"#", _x} -> nil
        {char, x} -> :digraph.add_vertex(racetrack, {x, y}, char)
      end)
    end)

    # add edges
    racetrack
    |> :digraph.vertices()
    |> Enum.each(fn v ->
      Digraph.add_edges(racetrack, edges(v))
    end)

    start =
      racetrack
      |> :digraph.vertices()
      |> Enum.map(&:digraph.vertex(racetrack, &1))
      |> Enum.find_value(fn
        {vertex, "S"} -> vertex
        _ -> false
      end)

    weight_graph(racetrack, start)

    racetrack
  end

  defp solve_1(racetrack) do
    racetrack
    |> :digraph.vertices()
    |> Enum.map(fn {x, y} = v1 ->
      [
        {x, y - 2},
        {x + 2, y},
        {x, y + 2},
        {x - 2, y}
      ]
      |> Enum.filter(fn v2 -> :digraph.vertex(racetrack, v2) end)
      |> Enum.filter(fn v2 ->
        {_, w1} = :digraph.vertex(racetrack, v1)
        {_, w2} = :digraph.vertex(racetrack, v2)

        w2 > w1 and w2 - w1 - 2 >= @timesave
      end)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp solve_2(racetrack) do
    racetrack
    |> :digraph.vertices()
    |> Enum.map(fn {x1, y1} = v1 ->
      racetrack
      |> :digraph.vertices()
      |> Enum.filter(fn {x2, y2} ->
        abs(y2 - y1) + abs(x2 - x1) <= 20
      end)
      |> Enum.filter(fn {x2, y2} = v2 ->
        {_, w1} = :digraph.vertex(racetrack, v1)
        {_, w2} = :digraph.vertex(racetrack, v2)

        w2 > w1 and w2 - w1 - abs(y2 - y1) - abs(x2 - x1) >= @timesave
      end)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  # relabel the graph with the weighted distance from the start vertex
  defp weight_graph(graph, start, distance \\ 0, visited \\ MapSet.new()) do
    :digraph.add_vertex(graph, start, distance)

    :digraph.out_edges(graph, start)
    |> Enum.map(&:digraph.edge(graph, &1))
    |> Enum.map(&elem(&1, 2))
    |> Enum.filter(fn v ->
      not MapSet.member?(visited, v)
    end)
    |> Enum.each(fn v ->
      weight_graph(graph, v, distance + 1, MapSet.put(visited, start))
    end)
  end

  defp edges({x, y}),
    do: [
      [{x, y}, {x, y - 1}],
      [{x, y}, {x + 1, y}],
      [{x, y}, {x, y + 1}],
      [{x, y}, {x - 1, y}]
    ]
end
