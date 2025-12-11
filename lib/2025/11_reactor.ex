defmodule AdventOfCode.Y2025.D11 do
  use AdventOfCode.Puzzle, year: 2025, day: 11
  use Memoize

  alias AdventOfCode.Helpers.Digraph

  @impl true
  def title, do: "Reactor"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    graph = :digraph.new()

    input
    |> String.trim()
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      [from, to] = String.split(line, ": ")

      {from, String.split(to, " ")}
    end)
    |> Enum.each(fn {from, to} ->
      Digraph.add_vertices(graph, [from | to])

      for v <- to do
        :digraph.add_edge(graph, from, v)
      end
    end)

    graph
  end

  defp solve_1(cables) do
    traverse_1(cables, "you")
  end

  defp solve_2(cables) do
    traverse_2(cables, "svr")
  end

  defp traverse_1(cables, current_node) do
    if current_node == "out" do
      1
    else
      cables
      |> :digraph.out_neighbours(current_node)
      |> Enum.sum_by(fn neighbor ->
        traverse_1(cables, neighbor)
      end)
    end
  end

  defmemop traverse_2(cables, current_node, fft? \\ false, dac? \\ false) do
    if current_node == "out" and fft? and dac? do
      1
    else
      cables
      |> :digraph.out_neighbours(current_node)
      |> Enum.sum_by(fn neighbor ->
        traverse_2(
          cables,
          neighbor,
          fft? or current_node == "fft",
          dac? or current_node == "dac"
        )
      end)
    end
  end
end
