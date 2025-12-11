defmodule AdventOfCode.Helpers.Digraph do
  @moduledoc """
  Digraph helper functions to complement Erlang's built-in `:digraph` module
  """

  @spec add_vertices(:digraph.graph(), list()) :: :ok
  def add_vertices(g, vs) do
    Enum.each(vs, fn v ->
      apply(:digraph, :add_vertex, [g, v])
    end)
  end

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

  @spec cliques(:digraph.graph()) :: [MapSet.t(:digraph.vertex())]
  def cliques(g) do
    bron_kerbosch(g)
  end

  # the basic form of the Bron-Kerbosch algorithm (without pivoting)
  defp bron_kerbosch(g) do
    p = :digraph.vertices(g) |> MapSet.new()
    bron_kerbosch(g, p)
  end

  defp bron_kerbosch(g, r \\ MapSet.new(), p, x \\ MapSet.new(), acc \\ []) do
    if Enum.empty?(p) and Enum.empty?(x) do
      [r | acc]
    else
      for v <- p, reduce: {r, p, x, acc} do
        {r, p, x, acc} ->
          n = neighbours(g, v) |> MapSet.new()

          acc =
            bron_kerbosch(
              g,
              MapSet.put(r, v),
              MapSet.intersection(p, n),
              MapSet.intersection(x, n)
            )
            |> Enum.concat(acc)

          p = MapSet.delete(p, v)
          x = MapSet.put(x, v)

          {r, p, x, acc}
      end
      |> elem(3)
    end
  end
end
