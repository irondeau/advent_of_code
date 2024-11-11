defmodule AdventOfCode.Helpers.Digraph do
  @moduledoc """
  Digraph helper functions to complement Erlang's built-in `:digraph` module
  """

  @spec del_edge(:digraph.graph(), :digraph.vertex(), :digraph.vertex()) :: :ok
  def del_edge(g, v1, v2) do
    :digraph.edges(g, v1)
    |> Enum.map(&:digraph.edge(g, &1))
    |> Enum.filter(&match?({_, _, ^v2, _}, &1))
    |> Enum.each(&:digraph.del_edge(g, elem(&1, 0)))
  end

  @spec neighbours(:digraph.graph(), :digraph.vertex()) :: [:digraph.vertex()]
  def neighbours(g, v) do
    :digraph.edges(g, v)
    |> Enum.map(&:digraph.edge(g, &1))
    |> Enum.flat_map(fn {_, v1, v2, _} -> [v1, v2] end)
    |> Enum.uniq()
    |> Enum.reject(& &1 == v)
  end
end
