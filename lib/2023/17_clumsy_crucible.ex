defmodule AdventOfCode.Y2023.D17 do
  use AdventOfCode.Puzzle, year: 2023, day: 17

  alias AdventOfCode.Helpers.PQ

  @impl true
  def title, do: "Clumsy Crucible"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    lines = String.split(input, ~r/\R/)

    graph = :digraph.new()

    # build vertices
    lines
    |> Enum.with_index()
    |> Enum.each(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.each(fn {char, x} ->
        :digraph.add_vertex(graph, {x, y}, String.to_integer(char))
      end)
    end)

    # build edges
    :digraph.vertices(graph)
    |> Enum.map(&:digraph.vertex(graph, &1))
    |> Enum.each(fn {{x, y}, heat} ->
      :digraph.add_edge(graph, {x, y + 1}, {x, y}, %{heat: heat, direction: :up})
      :digraph.add_edge(graph, {x, y - 1}, {x, y}, %{heat: heat, direction: :down})
      :digraph.add_edge(graph, {x + 1, y}, {x, y}, %{heat: heat, direction: :left})
      :digraph.add_edge(graph, {x - 1, y}, {x, y}, %{heat: heat, direction: :right})
    end)

    {graph, {0, 0}, :digraph.vertices(graph) |> Enum.max()}
  end

  defp solve_1({graph, start, stop}) do
    path_fn =
      fn d1, d2, count ->
        d1 != d2 or count < 3
      end

    pathfind(graph, start, stop, path_fn)
  end

  defp solve_2({graph, start, stop}) do
    path_fn =
      fn d1, d2, count ->
        :start in [d1, d2] or (count < 4 and d1 == d2) or (count >= 4 and count <= 10)
      end

    valid_fn =
      fn count ->
        (count >= 4 and count <= 10)
      end

    pathfind(graph, start, stop, path_fn, valid_fn)
  end

  defp pathfind(graph, start, stop, path_fn, valid_fn \\ fn _count -> true end) when is_tuple(start) and is_tuple(stop) and is_function(path_fn, 3) do
    pq =
      PQ.new(fn {_v1, h1, _d1, _c1}, {_v2, h2, _d2, _c2,} -> h1 < h2 end)
      |> PQ.push({start, 0, :start, 0})

    pathfind(graph, stop, pq, MapSet.new(), path_fn, valid_fn)
  end

  def pathfind(graph, stop, pq, visited, path_fn, valid_fn) when is_tuple(stop) and is_function(path_fn, 3) do
    with {{vertex, heat, direction, count}, pq} <- PQ.pop(pq) do
      if MapSet.member?(visited, {vertex, direction, count}) do
        pathfind(graph, stop, pq, visited, path_fn, valid_fn)
      else
        if vertex == stop and valid_fn.(count) do
          heat
        else
          visited = MapSet.put(visited, {vertex, direction, count})

          pq =
            :digraph.out_edges(graph, vertex)
            |> Enum.map(&:digraph.edge(graph, &1))
            |> Enum.reject(fn {_, _, _, %{direction: d2}} ->
              (direction == :up and d2 == :down)
              or (direction == :down and d2 == :up)
              or (direction == :left and d2 == :right)
              or (direction == :right and d2 == :left)
            end)
            |> Enum.reduce(pq, fn {_, _, v2, %{heat: h2, direction: d2}}, pq ->
              if path_fn.(direction, d2, count) do
                count = if d2 == direction, do: count + 1, else: 1
                PQ.push(pq, {v2, heat + h2, d2, count})
              else
                pq
              end
            end)

          pathfind(graph, stop, pq, visited, path_fn, valid_fn)
        end
      end
    end
  end
end
