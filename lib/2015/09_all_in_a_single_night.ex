defmodule AdventOfCode.Y2015.D9 do
  use AdventOfCode.Puzzle, year: 2015, day: 9

  @impl true
  def title, do: "All In A Single Night"

  @impl true
  def solve(input) do
    graph = build_graph(input)
    {solve_1(graph), solve_2(graph)}
  end

  @impl true
  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      Regex.named_captures(~r/(?<origin>\w+) to (?<dest>\w+) = (?<dist>\d+)/, line)
      |> Enum.into(%{}, fn {k, v} ->
        case k do
          "dist" -> {k, String.to_integer(v)}
          _ -> {k, String.to_atom(String.downcase(v))}
        end
      end)
    end)
  end

  defp solve_1(route_graph) do
    travel(route_graph, Map.keys(route_graph), &Enum.min/1)
  end

  defp solve_2(route_graph) do
    travel(route_graph, Map.keys(route_graph), &Enum.max/1)
  end

  defp build_graph(routes) do
    Enum.reduce(routes, %{}, fn %{"origin" => origin, "dest" => dest, "dist" => dist}, graph ->
      graph
      |> append(origin, {dest, dist})
      |> append(dest, {origin, dist})
    end)
  end

  defp append(map, key, value) do
    case Map.fetch(map, key) do
      {:ok, value_list} -> Map.put(map, key, [value | value_list])
      :error -> Map.put(map, key, [value])
    end
  end

  defp travel(route_graph, cities, op_fn) do
    cities
    |> Enum.map(&travel(route_graph, cities, &1, op_fn))
    |> op_fn.()
  end

  defp travel(route_graph, cities, city, op_fn, acc_dist \\ 0) do
    cities = List.delete(cities, city)

    (Enum.empty?(cities) && acc_dist) ||
      cities
      |> Enum.map(&travel(route_graph, cities, &1, op_fn, acc_dist + route_graph[city][&1]))
      |> op_fn.()
  end
end
