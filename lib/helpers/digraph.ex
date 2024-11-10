defmodule AdventOfCode.Helpers.Digraph do
  @spec del_edge(:digraph.graph(), :digraph.vertex(), :digraph.vertex()) :: :ok
  def del_edge(g, v1, v2) do
    :digraph.edges(g, v1)
    |> Enum.map(&:digraph.edge(g, &1))
    |> Enum.filter(&match?({_, _, ^v2, _}, &1))
    |> Enum.each(&:digraph.del_edge(g, elem(&1, 0)))
  end
end
