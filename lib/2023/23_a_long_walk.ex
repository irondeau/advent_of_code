defmodule AdventOfCode.Y2023.D23 do
  use AdventOfCode.Puzzle, year: 2023, day: 23

  alias Graph.Edge

  @impl true
  def title, do: "A Long Walk"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    lines = String.split(input, ~r/\R/)

    graph =
      lines
      |> Enum.with_index()
      |> Enum.reduce(Graph.new(), fn {line, y}, graph ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(graph, fn {char, x}, graph ->
            graph
            |> Graph.add_vertex({x, y})
            |> Graph.add_edges(get_edges(char, {x, y}))
        end)
      end)

    start = String.length(hd(lines)) - String.length(String.trim_leading(hd(lines), "#"))
    stop = String.length(String.trim_trailing(List.last(lines), "#")) - 1

    {graph, {start, 0}, {stop, length(lines) - 1}}
  end

  defp solve_1({graph, start, stop}) do
    Graph.get_paths(graph, start, stop)
    |> Enum.map(fn path -> length(path) - 1 end)
    |> Enum.max()
  end

  defp solve_2({graph, start, stop}) do
    Graph.get_paths(graph, start, stop)
    |> Enum.map(fn path -> length(path) - 1 end)
    |> Enum.max()
  end

  defp get_edges("#", {_x, _y}), do: []
  # defp get_edges("^", {x, y}), do: [Edge.new({x, y}, {x, y - 1})]
  # defp get_edges(">", {x, y}), do: [Edge.new({x, y}, {x + 1, y})]
  # defp get_edges("v", {x, y}), do: [Edge.new({x, y}, {x, y + 1})]
  # defp get_edges("<", {x, y}), do: [Edge.new({x, y}, {x - 1, y})]

  defp get_edges(_, {x, y}) do
    [
      Edge.new({x, y}, {x, y - 1}),
      Edge.new({x, y}, {x + 1, y}),
      Edge.new({x, y}, {x, y + 1}),
      Edge.new({x, y}, {x - 1, y})
    ]
  end
end
