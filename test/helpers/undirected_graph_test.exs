defmodule AdventOfCodeTest.Helpers.UndirectedGraphTest do
  use ExUnit.Case, async: true

  alias AdventOfCode.Helpers.UndirectedGraph

  test "add vertices" do
    graph =
      UndirectedGraph.new()
      |> UndirectedGraph.add_vertex(:a)
      |> UndirectedGraph.add_vertex(:b)
      |> UndirectedGraph.add_vertex(:c)
      |> UndirectedGraph.add_vertices([:d, :e])

    assert length(UndirectedGraph.vertices(graph)) == 5
  end

  test "add edges" do
    graph =
      UndirectedGraph.new()
      |> UndirectedGraph.add_vertices([:a, :b, :c, :d])
      |> UndirectedGraph.add_edge(:a, :b)
      |> UndirectedGraph.add_edges([{:b, :c, [weight: 2]}])
      |> UndirectedGraph.add_edge(:a, :b)

    assert length(Map.keys(UndirectedGraph.edges(graph))) == 3
  end

  test "delete vertices" do
    graph =
      UndirectedGraph.new()
      |> UndirectedGraph.add_vertices([:a, :b, :c, :d, :e, :f])
      |> UndirectedGraph.add_edges([{:a, :b}, {:a, :c}, {:b, :d}, {:b, :e}, {:e, :f}])
      |> UndirectedGraph.delete_vertex(:a)
      |> UndirectedGraph.delete_vertices([:e, :f])

    assert length(UndirectedGraph.vertices(graph)) == 3
    assert length(Map.keys(UndirectedGraph.edges(graph))) == 1
  end

  test "delete edges" do
    graph =
      UndirectedGraph.new()
      |> UndirectedGraph.add_vertices([:a, :b, :c, :d])
      |> UndirectedGraph.add_edge(:a, :b)
      |> UndirectedGraph.add_edges([{:b, :c, [weight: 2]}])
      |> UndirectedGraph.add_edge(:a, :b)

    assert length(Map.keys(UndirectedGraph.edges(graph))) == 3
  end
end
