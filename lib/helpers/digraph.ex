defmodule AdventOfCode.Helpers.Digraph do
  @moduledoc """
  Digraph helper functions to complement Erlang's built-in `:digraph` module
  """

  @spec add_edges(:digraph.graph(), list()) :: :ok
  def add_edges(g, es) do
    Enum.each(es, fn e ->
      apply(:digraph, :add_edge, [g | e])
    end)
  end

  @spec del_edges(:digraph.graph(), :digraph.vertex(), :digraph.vertex()) :: :ok
  def del_edges(g, v1, v2) do
    edges(g, v1, v2)
    |> Enum.each(&:digraph.del_edge(g, &1))
  end

  @spec edges(:digraph.graph(), :digraph.vertex(), :digraph.vertex()) :: [:digraph.edge()]
  def edges(g, v1, v2) do
    :digraph.edges(g)
    |> Enum.filter(fn e ->
      edge = :digraph.edge(g, e)
      match?({_, ^v1, ^v2, _}, edge) or match?({_, ^v2, ^v1, _}, edge)
    end)
  end

  @spec neighbours(:digraph.graph(), :digraph.vertex()) :: [:digraph.vertex()]
  def neighbours(g, v) do
    :digraph.edges(g, v)
    |> Enum.map(&:digraph.edge(g, &1))
    |> Enum.flat_map(fn {_, v1, v2, _} -> [v1, v2] end)
    |> Enum.uniq()
    |> Enum.reject(&(&1 == v))
  end
end
