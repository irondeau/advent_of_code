defmodule AdventOfCode.Y2023.D10 do
  use AdventOfCode.Puzzle, year: 2023, day: 10

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

    graph = :digraph.new()

    start =
      lines
      |> Enum.with_index()
      |> Enum.reduce(nil, fn {line, y}, start ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(start, fn {char, x}, start ->
          case char do
            "." -> start
            "S" -> {x, y}
            char ->
              :digraph.add_vertex(graph, {x, y}, to_label(char))

              neighbors_for(char, {x, y})
              |> Enum.each(fn neighbor ->
                if :digraph.vertex(graph, neighbor) == false do
                  :digraph.add_vertex(graph, neighbor)
                end

                :digraph.add_edge(graph, {x, y}, neighbor)
              end)

              start
          end
        end)
      end)

    add_start_vertex(graph, start)

    size_x = hd(lines) |> String.length()
    size_y = length(lines)

    {graph, start, {size_x, size_y}}
  end

  defp solve_1({graph, start, _size}) do
    :digraph.get_cycle(graph, start)
    |> length()
    |> div(2)
  end

  defp solve_2({graph, start, {size_x, size_y}}) do
    path = :digraph.get_cycle(graph, start) |> tl()

    empty_tiles =
      for y <- 0..size_y,
          x <- 0..size_x do
        {x, y}
      end
      |> Enum.reject(&(&1 in path))

    empty_tiles
    |> Enum.filter(fn {tile_x, tile_y} ->
      path
      |> Enum.filter(fn {x, y} ->
        y == tile_y && x < tile_x
      end)
      |> Enum.sort_by(&elem(&1, 0), :asc)
      |> Enum.reduce({0, []}, fn vertex, {count, prev_corners} ->
        {_, label} = :digraph.vertex(graph, vertex)
        cond do
          MapSet.equal?(label, to_label("|")) -> {count + 1, prev_corners}
          MapSet.equal?(label, to_label("-")) -> {count, prev_corners}
          MapSet.equal?(label, to_label("J")) ->
            if MapSet.equal?(hd(prev_corners), to_label("F")) do
              {count + 1, tl(prev_corners)}
            else
              {count, tl(prev_corners)}
            end
          MapSet.equal?(label, to_label("7")) ->
            if MapSet.equal?(hd(prev_corners), to_label("L")) do
              {count + 1, tl(prev_corners)}
            else
              {count, tl(prev_corners)}
            end
          true ->
            {count, [label | prev_corners]}
        end
      end)
      |> elem(0)
      |> rem(2)
      |> Kernel.==(1)
    end)
    |> Enum.count()
  end

  defp to_label("|"), do: MapSet.new([:up, :down])
  defp to_label("-"), do: MapSet.new([:left, :right])
  defp to_label("L"), do: MapSet.new([:up, :right])
  defp to_label("J"), do: MapSet.new([:up, :left])
  defp to_label("7"), do: MapSet.new([:down, :left])
  defp to_label("F"), do: MapSet.new([:down, :right])

  defp neighbors_for("|", {x, y}), do: [{x, y - 1}, {x, y + 1}]
  defp neighbors_for("-", {x, y}), do: [{x - 1, y}, {x + 1, y}]
  defp neighbors_for("L", {x, y}), do: [{x + 1, y}, {x, y - 1}]
  defp neighbors_for("J", {x, y}), do: [{x - 1, y}, {x, y - 1}]
  defp neighbors_for("7", {x, y}), do: [{x - 1, y}, {x, y + 1}]
  defp neighbors_for("F", {x, y}), do: [{x + 1, y}, {x, y + 1}]

  defp add_start_vertex(graph, {start_x, start_y} = start) do
    start_label =
      :digraph.in_neighbours(graph, start)
      |> Enum.map(fn {x, y} ->
        if start_y == y do
          if start_x < x, do: :right, else: :left
        else
          if start_y < y, do: :down, else: :up
        end
      end)
      |> MapSet.new()

    :digraph.add_vertex(graph, start, start_label)

    # flip one edge around so starting vertex has one ingress and one egress
    [edge | _] = :digraph.in_edges(graph, start)
    {_, neighbor, _, _} = :digraph.edge(graph, edge)
    :digraph.del_edge(graph, edge)
    :digraph.add_edge(graph, start, neighbor)
  end
end
