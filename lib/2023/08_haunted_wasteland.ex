defmodule AdventOfCode.Y2023.D8 do
  use AdventOfCode.Puzzle, year: 2023, day: 8

  import AdventOfCode.Helpers.Math

  @impl true
  def title, do: "Haunted Wasteland"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    [instr, network] = String.split(input, ~r/\R\R/, parts: 2)

    graph = :digraph.new()

    network
    |> String.split(~r/\R/)
    |> Enum.map(&String.split(&1, ~r/[=(,) ]+/, trim: true))
    |> Enum.each(fn [node, left, right] ->
      :digraph.add_vertex(graph, node)
      :digraph.add_vertex(graph, left)
      :digraph.add_vertex(graph, right)
      :digraph.add_edge(graph, node, left, :left)
      :digraph.add_edge(graph, node, right, :right)
    end)

    instr =
      instr
      |> String.graphemes()
      |> Enum.map(fn direction -> if direction == "L", do: :left, else: :right end)

    {graph, instr}
  end

  defp solve_1({graph, instr}) do
    traverse_1(graph, instr, "AAA")
  end

  defp solve_2({graph, instr}) do
    graph
    |> :digraph.vertices()
    |> Enum.filter(&(String.last(&1) == "A"))
    |> Enum.map(fn node ->
      traverse_2(graph, instr, node)
    end)
    |> lcm()
  end

  defp traverse_1(graph, instr, node, acc \\ 0)
  defp traverse_1(_graph, _instr, "ZZZ", acc), do: acc

  defp traverse_1(graph, instr, node, acc) do
    node =
      Enum.reduce(instr, node, fn direction, current_node ->
        graph
        |> :digraph.out_edges(current_node)
        |> Enum.map(&:digraph.edge(graph, &1))
        |> Enum.find(fn {_, _v1, _v2, label} -> label == direction end)
        |> elem(2)
      end)

    traverse_1(graph, instr, node, acc + length(instr))
  end

  defp traverse_2(graph, instr, node, acc \\ 0) do
    if String.last(node) == "Z" do
      acc
    else
      node =
        Enum.reduce(instr, node, fn direction, current_node ->
          graph
          |> :digraph.out_edges(current_node)
          |> Enum.map(&:digraph.edge(graph, &1))
          |> Enum.find(fn {_, _v1, _v2, label} -> label == direction end)
          |> elem(2)
        end)

      traverse_2(graph, instr, node, acc + length(instr))
    end
  end
end
