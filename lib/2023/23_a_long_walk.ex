defmodule AdventOfCode.Y2023.D23 do
  use AdventOfCode.Puzzle, year: 2023, day: 23

  alias AdventOfCode.Helpers.Digraph

  @impl true
  def title, do: "A Long Walk"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    lines = String.split(input, ~r/\R/)

    path =
      lines
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, path ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(path, fn {char, x}, path ->
          if char in ~w/. ^ > v </ do
            cond do
              y == 0 and char == "." ->
                Map.put(path, :start, {x, y})

              y == length(lines) - 1 and char == "." ->
                Map.put(path, :stop, {x, y})

              true ->
                path
            end
            |> Map.put({x, y}, char)
          else
            path
          end
        end)
      end)

    {start, path} = Map.pop!(path, :start)
    {stop, path} = Map.pop!(path, :stop)

    {path, start, stop}
  end

  defp solve_1({path, start, stop}) do
    {flat_path, sloped_path} =
      Map.split_with(path, &(elem(&1, 1) == "."))

    graph = :digraph.new()

    Enum.each(flat_path, fn {vertex, char} ->
      :digraph.add_vertex(graph, vertex, char)
    end)

    add_path(graph, flat_path)

    Enum.each(sloped_path, fn {vertex, char} ->
      :digraph.add_vertex(graph, vertex, char)
    end)

    add_path(graph, sloped_path)

    reduce(graph)

    solve(graph, start, stop)
  end

  defp solve_2({path, start, stop}) do
    path =
      Map.new(path, fn {{x, y}, _char} -> {{x, y}, "."} end)

    graph = :digraph.new()

    Enum.each(path, fn {vertex, char} ->
      :digraph.add_vertex(graph, vertex, char)
    end)

    add_path(graph, path)

    reduce(graph)

    solve(graph, start, stop)
  end

  defp solve(graph, start, stop) do
    get_paths(graph, start, stop)
    |> Enum.map(fn path ->
      get_in(path, [Access.all(), Access.elem(3), Access.key!(:weight)])
      |> Enum.sum()
    end)
    |> Enum.max()
  end

  defp add_path(graph, path) do
    path
    |> Enum.flat_map(&map_step/1)
    |> Enum.each(fn {v1, v2} ->
      :digraph.add_edge(graph, v1, v2, %{weight: 1})
    end)
  end

  defp map_step({{x, y}, "."}),
    do: [
      {{x, y}, {x, y - 1}},
      {{x, y}, {x + 1, y}},
      {{x, y}, {x, y + 1}},
      {{x, y}, {x - 1, y}}
    ]

  defp map_step({{x, y}, "^"}), do: [{{x, y + 1}, {x, y}}, {{x, y}, {x, y - 1}}]
  defp map_step({{x, y}, ">"}), do: [{{x - 1, y}, {x, y}}, {{x, y}, {x + 1, y}}]
  defp map_step({{x, y}, "v"}), do: [{{x, y - 1}, {x, y}}, {{x, y}, {x, y + 1}}]
  defp map_step({{x, y}, "<"}), do: [{{x + 1, y}, {x, y}}, {{x, y}, {x - 1, y}}]

  defp reduce(graph) do
    vertices = :digraph.vertices(graph)

    Enum.each(vertices, fn vertex ->
      if :digraph.out_degree(graph, vertex) == 2 and length(Digraph.neighbours(graph, vertex)) == 2 do
        [{_, _, v1, %{weight: w1}}, {_, _, v2, %{weight: w2}}] =
          :digraph.out_edges(graph, vertex)
          |> Enum.map(&:digraph.edge(graph, &1))

        :digraph.del_vertex(graph, vertex)
        :digraph.add_edge(graph, v1, v2, %{weight: w1 + w2})
        :digraph.add_edge(graph, v2, v1, %{weight: w1 + w2})
      end
    end)
  end

  defp get_paths(graph, v1, v2), do: get_paths(graph, v2, [{v1, []}], [])

  defp get_paths(_graph, _v2, [], paths), do: paths

  defp get_paths(graph, v2, [{vertex, visited} | unvisited], paths) when vertex == v2 do
    get_paths(graph, v2, unvisited, [visited | paths])
  end

  defp get_paths(graph, v2, [{vertex, visited} | unvisited], paths) do
    :digraph.out_edges(graph, vertex)
    |> Enum.map(&:digraph.edge(graph, &1))
    |> Enum.reject(fn {_, _, v2, _} ->
      Enum.any?(visited, &match?({_, ^v2, _, _}, &1))
    end)
    |> Enum.map(&{elem(&1, 2), [&1 | visited]})
    |> then(fn to_visit ->
      get_paths(graph, v2, to_visit ++ unvisited, paths)
    end)
  end
end
