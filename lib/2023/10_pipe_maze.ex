defmodule AdventOfCode.Y2023.D10 do
  use AdventOfCode.Puzzle, year: 2023, day: 10

  alias Graph.Edge

  @impl true
  def title, do: "Pipe Maze"

  @impl true
  def solve(input) do
    input
    |> then(&{solve_1(&1), solve_2(&1)})
  end

  @impl true
  def parse(input) do
    lines = String.split(input, ~r/\R/)

    {graph, start} =
      lines
      |> Enum.with_index()
      |> Enum.reduce({Graph.new(), nil}, fn {line, y}, acc ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {char, x}, {graph, start} ->
          cond do
            char == "S" ->
              {graph, {x, y}}

            char != "." ->
              graph =
                graph
                |> Graph.add_vertex({x, y})
                |> Graph.label_vertex({x, y}, to_label(char))
                |> Graph.add_edges(edges_for(char, {x, y}))

              {graph, start}

            true ->
              {graph, start}
          end
        end)
      end)

    size_x = hd(lines) |> String.length()
    size_y = length(lines)

    {add_start_vertex(graph, start), start, {size_x, size_y}}
  end

  defp solve_1({graph, start, _size}) do
    Graph.get_paths(graph, start, start)
    |> Enum.map(&length/1)
    |> Enum.max()
    |> then(&(div(&1, 2)))
  end

  defp solve_2({graph, start, {size_x, size_y}}) do
    path = Graph.get_paths(graph, start, start) |> hd()
    loop = Graph.subgraph(graph, [start | path])
    loop_vertices = Graph.vertices(loop)

    all_tiles =
      for y <- 0..size_y,
          x <- 0..size_x do
        {x, y}
      end

    empty_tiles = Enum.filter(all_tiles, &(&1 not in loop_vertices))

    empty_tiles
    |> Enum.filter(fn {tile_x, tile_y} ->
      loop_vertices
      |> Enum.filter(fn {x, y} ->
        y == tile_y && x < tile_x
      end)
      |> Enum.sort_by(&(elem(&1, 0)), :asc)
      |> Enum.reduce({0, []}, fn vertex, {count, prev_corners} ->
        case Graph.vertex_labels(loop, vertex) |> hd() do
          :updown -> {count + 1, prev_corners}
          :leftright -> {count, prev_corners}
          :upright -> {count, [:upright | prev_corners]}
          :downright -> {count, [:downright | prev_corners]}
          :upleft ->
            if hd(prev_corners) == :downright do
              {count + 1, tl(prev_corners)}
            else
              {count, tl(prev_corners)}
            end
          :downleft ->
            if hd(prev_corners) == :upright do
              {count + 1, tl(prev_corners)}
            else
              {count, tl(prev_corners)}
            end
        end
      end)
      |> elem(0)
      |> then(&(rem(&1, 2) == 1))
    end)
    |> Enum.count()
  end

  defp to_label("|"), do: :updown
  defp to_label("-"), do: :leftright
  defp to_label("L"), do: :upright
  defp to_label("J"), do: :upleft
  defp to_label("7"), do: :downleft
  defp to_label("F"), do: :downright

  defp edges_for("|", {x, y} = coord), do: [Edge.new(coord, {x, y - 1}), Edge.new(coord, {x, y + 1})]
  defp edges_for("-", {x, y} = coord), do: [Edge.new(coord, {x - 1, y}), Edge.new(coord, {x + 1, y})]
  defp edges_for("L", {x, y} = coord), do: [Edge.new(coord, {x + 1, y}), Edge.new(coord, {x, y - 1})]
  defp edges_for("J", {x, y} = coord), do: [Edge.new(coord, {x - 1, y}), Edge.new(coord, {x, y - 1})]
  defp edges_for("7", {x, y} = coord), do: [Edge.new(coord, {x - 1, y}), Edge.new(coord, {x, y + 1})]
  defp edges_for("F", {x, y} = coord), do: [Edge.new(coord, {x + 1, y}), Edge.new(coord, {x, y + 1})]

  defp add_start_vertex(graph, {x, y} = vertex) do
    graph = Graph.add_vertex(graph, vertex)
    neighbors = Graph.neighbors(graph, vertex)

    {graph, outbound} =
      neighbors
      |> Enum.reduce({graph, []}, fn {neighbor_x, neighbor_y} = neighbor, {graph, acc} ->
        graph = Graph.add_edge(graph, vertex, neighbor)

        acc =
          if neighbor_y == y do
            if neighbor_x < x, do: [:left | acc], else: [:right | acc]
          else
            if neighbor_y < y, do: [:up | acc], else: [:down | acc]
          end

        {graph, acc}
      end)

    cond do
      Enum.all?(outbound, &(&1 in [:left, :up])) ->
        Graph.label_vertex(graph, vertex, :upleft)

      Enum.all?(outbound, &(&1 in [:right, :up])) ->
        Graph.label_vertex(graph, vertex, :upright)

      Enum.all?(outbound, &(&1 in [:left, :down])) ->
        Graph.label_vertex(graph, vertex, :downleft)

      Enum.all?(outbound, &(&1 in [:right, :down])) ->
        Graph.label_vertex(graph, vertex, :downright)
    end
  end
end
