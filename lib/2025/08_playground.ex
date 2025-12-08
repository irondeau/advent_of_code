defmodule AdventOfCode.Y2025.D8 do
  use AdventOfCode.Puzzle, year: 2025, day: 8

  alias AdventOfCode.Helpers

  @impl true
  def title, do: "Playground"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    {[connections_input], junction_boxes_input} =
      input
      |> String.trim()
      |> String.split(~r/\R/)
      |> Enum.split(1)

    connections = String.to_integer(connections_input)

    junction_boxes =
      junction_boxes_input
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)

    {junction_boxes, connections}
  end

  defp solve_1({junction_boxes, connections}) do
    graph = :digraph.new()

    junction_boxes
    |> Helpers.Enum.combinations(2)
    |> Enum.sort_by(&distance/1)
    |> Enum.take(connections)
    |> Enum.each(fn [v1, v2] ->
      :digraph.add_vertex(graph, v1)
      :digraph.add_vertex(graph, v2)
      :digraph.add_edge(graph, v1, v2)
      :digraph.add_edge(graph, v2, v1)
    end)

    :digraph_utils.components(graph)
    |> Enum.sort_by(&length/1, :desc)
    |> Enum.take(3)
    |> Enum.product_by(&length/1)
  end

  defp solve_2({junction_boxes, _connections}) do
    graph = :digraph.new()

    junction_boxes
    |> Enum.each(fn v ->
      :digraph.add_vertex(graph, v)
    end)

    junction_boxes
    |> Helpers.Enum.combinations(2)
    |> Enum.sort_by(&distance/1)
    |> Enum.reduce_while(nil, fn [v1, v2], _ ->
      :digraph.add_edge(graph, v1, v2)
      :digraph.add_edge(graph, v2, v1)

      if length(:digraph_utils.components(graph)) == 1 do
        {:halt, [v1, v2]}
      else
        {:cont, nil}
      end
    end)
    |> Enum.product_by(&hd/1)
  end

  defp distance([[x1, y1, z1], [x2, y2, z2]]) do
    :math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2)
  end
end
