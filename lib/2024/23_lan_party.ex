defmodule AdventOfCode.Y2024.D23 do
  use AdventOfCode.Puzzle, year: 2024, day: 23

  alias AdventOfCode.Helpers.Digraph

  @impl true
  def title, do: "LAN Party"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    connections =
      input
      |> String.split(~r/\R/)
      |> Enum.map(&String.split(&1, "-"))

    network = :digraph.new()

    connections
    |> List.flatten()
    |> Enum.each(&:digraph.add_vertex(network, &1))

    Enum.each(connections, fn [v1, v2] ->
      :digraph.add_edge(network, v1, v2)
      :digraph.add_edge(network, v2, v1)
    end)

    network
  end

  defp solve_1(network) do
    network
    |> get_parties_of_3()
    |> Enum.filter(fn party -> Enum.any?(party, &String.starts_with?(&1, "t")) end)
    |> Enum.count()
  end

  defp solve_2(network) do
    network
    |> Digraph.cliques()
    |> Enum.max_by(&MapSet.size/1)
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp get_parties_of_3(network) do
    for v1 <- :digraph.vertices(network),
        v2 <- :digraph.out_neighbours(network, v1),
        v3 <- :digraph.out_neighbours(network, v1),
        v2 != v3,
        v3 in :digraph.out_neighbours(network, v2) do
      MapSet.new([v1, v2, v3])
    end
    |> Enum.uniq()
  end
end
