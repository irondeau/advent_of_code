defmodule AdventOfCode.Y2015.D13 do
  use AdventOfCode.Puzzle, year: 2015, day: 13

  alias AdventOfCode.Helpers
  alias AdventOfCode.Helpers.Digraph

  @impl true
  def title, do: "Knights of the Dinner Table"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    graph = :digraph.new()

    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      Regex.named_captures(~r/(?<subject>\w+) would (?<sign>gain|lose) (?<units>\d+) happiness units by sitting next to (?<target>\w+)./, line)
    end)
    |> Enum.each(fn preference ->
      weight =
        preference["units"]
        |> String.to_integer()
        |> Kernel.*(if preference["sign"] == "gain", do: 1, else: -1)

      :digraph.add_vertex(graph, preference["subject"])
      :digraph.add_vertex(graph, preference["target"])
      :digraph.add_edge(graph, preference["subject"], preference["target"], %{weight: weight})
    end)

    graph
  end

  defp solve_1(graph), do: score(graph)

  defp solve_2(graph) do
    graph = :digraph_utils.subgraph(graph, :digraph.vertices(graph))

    :digraph.add_vertex(graph, "Me")

    :digraph.vertices(graph)
    |> Enum.each(fn target ->
      :digraph.add_edge(graph, "Me", target, %{weight: 0})
      :digraph.add_edge(graph, target, "Me", %{weight: 0})
    end)

    score(graph)
  end

  defp score(graph) do
    :digraph.vertices(graph)
    |> Helpers.Enum.permutations()
    |> Enum.map(fn seating_arrangement ->
      seating_arrangement
      |> Enum.chunk_every(2, 1, [hd(seating_arrangement)])
      |> Enum.flat_map(fn [subject, target] ->
        Digraph.edges(graph, subject, target)
        |> Enum.map(fn e ->
          :digraph.edge(graph, e)
          |> get_in([Access.elem(3), Access.key(:weight)])
        end)
      end)
      |> Enum.sum()
    end)
    |> Enum.max()
  end
end
