defmodule AdventOfCode.Y2023.D23 do
  use AdventOfCode.Puzzle, year: 2023, day: 23

  require IEx
  alias AdventOfCode.Helpers.DirectedGraph

  @impl true
  def title, do: "A Long Walk"

  @impl true
  def solve(input) do
    input
    |> then(&{solve_1(&1), solve_2(&1)})
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

    graph =
      DirectedGraph.new()
      |> DirectedGraph.add_vertices(Map.keys(flat_path))
      |> add_path(flat_path)
      |> DirectedGraph.add_vertices(Map.keys(sloped_path))
      |> add_path(sloped_path)
      |> reduce()

    DirectedGraph.get_paths(graph, start, stop)
    |> Enum.map(fn path ->
      get_in(Map.to_list(path), [Access.all(), Access.elem(1), Access.key!(:weight)])
      |> Enum.sum()
    end)
    |> Enum.max()
  end

  defp solve_2({path, start, stop}) do
    path =
      Map.new(path, fn {{x, y}, _char} -> {{x, y}, "."} end)

    graph =
      DirectedGraph.new()
      |> DirectedGraph.add_vertices(Map.keys(path))
      |> add_path(path)
      |> reduce()

    DirectedGraph.get_paths(graph, start, stop)
    |> Enum.map(fn path ->
      get_in(Map.to_list(path), [Access.all(), Access.elem(1), Access.key!(:weight)])
      |> Enum.sum()
    end)
    |> Enum.max()
  end

  defp add_path(graph, path) do
    DirectedGraph.add_edges(graph, Enum.flat_map(path, &map_step/1), add_vertices: false)
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
    graph
    |> DirectedGraph.vertices()
    |> Enum.reduce(graph, fn vertex, graph ->
      out_edges = DirectedGraph.out_edges(graph, vertex)

      if map_size(out_edges) == 2 and length(DirectedGraph.neighbors(graph, vertex)) == 2 do
        [v1, v2] =
          Enum.map(out_edges, & elem(&1, 1).v2)

        combined_weight =
          out_edges
          |> Enum.map(& elem(&1, 1).weight)
          |> Enum.sum()

        graph
        |> DirectedGraph.delete_vertex(vertex)
        |> DirectedGraph.add_edge(v1, v2, weight: combined_weight)
        |> DirectedGraph.add_edge(v2, v1, weight: combined_weight)
      else
        graph
      end
    end)
  end
end
