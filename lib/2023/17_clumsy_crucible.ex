defmodule AdventOfCode.Y2023.D17 do
  use AdventOfCode.Puzzle, year: 2023, day: 17

  # Disclaimer: I gave up on this problem because Elixir does not have a priority queue
  # which I can use to solve this problem. I tried utilizing the implementation that
  # the Graph library provides, but there is no way to check if an item has already
  # been added to the queue.
  #
  # The problem I faced when I finally gave up was that multiple v2 vertices were being
  # added to the priority queue for the pathfinding algorithm, making the path from any
  # vertex to the root of the generated tree uncertain.

  @impl true
  def title, do: "Clumsy Crucible"

  @impl true
  def solve(input) do
    input
    |> then(&{solve_1(&1), solve_2(&1)})
  end

  @impl true
  def parse(input) do
    map =
      input
      |> String.split(~r/\R/)
      |> Enum.map(fn line ->
        line
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)
      end)

    dst = {hd(map) |> length(), length(map)}

    # graph =
    #   input
    #   |> Enum.with_index()
    #   |> Enum.reduce(Graph.new(), fn {line, y}, graph ->
    #     line
    #     |> Enum.with_index()
    #     |> Enum.reduce(graph, fn {weight, x}, graph ->
    #       graph
    #       |> Graph.add_vertex({x, y})
    #       |> Graph.add_edges(edges({x, y}, String.to_integer(weight)))
    #     end)
    #   end)
    #   |> Graph.add_vertex(dst)
    #   |> Graph.add_edge({dst_x - 1, dst_y - 1}, dst,
    #     weight: get_in(input, [Access.at(dst_y - 1), Access.at(dst_x - 1)]) |> String.to_integer()
    #   )

    {map, dst}
  end

  defp solve_1({_map, _dst}) do
    # graph
    # |> pathfind({0, 0}, dst, fn tree, %Edge{v1: v1, v2: v2} = edge ->
    #   path_vertices =
    #     tree
    #     |> Graph.add_vertex(v2)
    #     |> Graph.add_edge(v2, v1)
    #     |> build_path(edge)
    #     |> Enum.reduce([], fn edge, vertices ->
    #       [edge.v1 | [edge.v2 | vertices]]
    #     end)
    #     |> Enum.uniq()

    #   path_vertices
    #   |> Enum.unzip()
    #   |> Tuple.to_list()
    #   |> Enum.map(fn axis ->
    #     axis
    #     |> Enum.chunk_every(2, 1, :discard)
    #     |> Enum.reduce_while(1, fn [a, b], acc ->
    #       if a == b do
    #         {:cont, acc + 1}
    #       else
    #         {:halt, acc}
    #       end
    #     end)
    #   end)
    #   |> Enum.max()
    #   |> Kernel.>=(4)
    # end)
    # |> Enum.map(& &1.weight)
    # |> Enum.sum()

    nil
  end

  defp solve_2(_input) do
    nil
  end

  # defp edges({x, y} = vertex, weight) do
  #   [
  #     Edge.new(vertex, {x, y - 1}, weight: weight),
  #     Edge.new(vertex, {x, y + 1}, weight: weight),
  #     Edge.new(vertex, {x - 1, y}, weight: weight),
  #     Edge.new(vertex, {x + 1, y}, weight: weight)
  #   ]
  # end

  # defp pathfind(graph, a, b, reject_fun) do
  #   tree = Graph.new() |> Graph.add_vertex(a)

  #   queue =
  #     graph
  #     |> Graph.out_edges(a)
  #     |> Enum.reduce(PriorityQueue.new(), fn edge, queue ->
  #       PriorityQueue.push(queue, {edge, edge.weight}, edge.weight)
  #     end)

  #   search(queue, graph, b, tree, reject_fun)
  # end

  # defp search(queue, graph, target_vertex, tree, reject_fun) do
  #   case PriorityQueue.pop(queue) do
  #     {{:value, {%Edge{v1: v1, v2: ^target_vertex} = edge, _}}, _queue} ->
  #       tree
  #       |> Graph.add_vertex(target_vertex)
  #       |> Graph.add_edge(target_vertex, v1, weight: edge.weight)
  #       |> build_path(edge)

  #     {{:value, {%Edge{v1: v1, v2: v2, weight: weight} = edge, acc_weight}}, queue} ->
  #       if edge in Graph.edges(tree) do
  #         search(queue, graph, target_vertex, tree, reject_fun)
  #       else
  #         case Graph.out_edges(graph, v2) do
  #           nil ->
  #             search(queue, graph, target_vertex, tree, reject_fun)

  #           v2_out ->
  #             tree =
  #               tree
  #               |> Graph.add_vertex(v2)
  #               |> Graph.add_edge(v2, v1, weight: weight)

  #             # if {4, 2} in get_in(v2_out, [Access.all(), Access.key!(:v2)]), do: pry()

  #             queue =
  #               v2_out
  #               |> Enum.reject(fn %Edge{v2: v2} -> v2 in Graph.vertices(tree) end)
  #               |> Enum.reject(fn edge -> edge in get_in(queue, [Access.key!(:priorities), Access.elem(0)]) end)
  #               |> Enum.reject(fn edge -> reject_fun.(tree, edge) end)
  #               |> Enum.reduce(queue, fn edge, queue ->
  #                 PriorityQueue.push(queue, {edge, acc_weight + edge.weight}, edge.weight)
  #               end)

  #             search(queue, graph, target_vertex, tree, reject_fun)
  #         end
  #       end

  #     {{:empty, _}} ->
  #       raise ArgumentError
  #   end
  # end

  # def build_path(tree, %Edge{v2: v2}, path \\ []) do
  #   case Graph.out_edges(tree, v2) do
  #     [] ->
  #       path

  #     [edge] ->
  #       build_path(tree, edge, [edge | path])
  #   end
  # end
end
