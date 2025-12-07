defmodule AdventOfCode.Y2025.D7 do
  use AdventOfCode.Puzzle, year: 2025, day: 7
  use Memoize

  require IEx

  @impl true
  def title, do: "Laboratories"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    graph = :digraph.new()

    matrix =
      input
      |> String.split(~r/\R/)
      |> Enum.take_every(2)
      |> Enum.map(&String.graphemes/1)

    start =
      matrix
      |> Enum.with_index()
      |> Enum.reduce(nil, fn {line, y}, start ->
        line
        |> Enum.with_index()
        |> Enum.reduce(start, fn
          {char, x}, start ->
            :digraph.add_vertex(graph, {x, y})

            case char do
              "^" ->
                :digraph.add_vertex(graph, {x - 1, y})
                :digraph.add_vertex(graph, {x + 1, y})
                :digraph.add_edge(graph, {x, y}, {x - 1, y})
                :digraph.add_edge(graph, {x, y}, {x + 1, y})

              _ ->
                :digraph.add_vertex(graph, {x, y + 1})
                :digraph.add_edge(graph, {x, y}, {x, y + 1})
            end

            if char == "S" do
              {x, y}
            else
              start
            end
        end)
      end)

    {graph, start}
  end

  defp solve_1({graph, start}) do
    graph
    |> traverse_1(start)
    |> MapSet.size()
  end

  defp solve_2({graph, start}) do
    graph
    |> traverse_2(start)
  end

  defmemop traverse_1(graph, current_node) do
    graph
    |> :digraph.out_edges(current_node)
    |> Enum.map(&:digraph.edge(graph, &1))
    |> case do
      [] ->
        MapSet.new()

      [{_, ^current_node, v1, []}] ->
        traverse_1(graph, v1)

      [{_, ^current_node, v1, []}, {_, ^current_node, v2, []}] ->
        n1 = traverse_1(graph, v1)
        n2 = traverse_1(graph, v2)

        MapSet.union(n1, n2) |> MapSet.put(current_node)
    end
  end

  defmemop traverse_2(graph, current_node) do
    graph
    |> :digraph.out_edges(current_node)
    |> Enum.map(&:digraph.edge(graph, &1))
    |> case do
      [] ->
        1

      [{_, ^current_node, v1, []}] ->
        traverse_2(graph, v1)

      [{_, ^current_node, v1, []}, {_, ^current_node, v2, []}] ->
        n1 = traverse_2(graph, v1)
        n2 = traverse_2(graph, v2)

        n1 + n2
    end
  end
end
