defmodule AdventOfCode.Y2025.D4 do
  use AdventOfCode.Puzzle, year: 2025, day: 4

  @impl true
  def title, do: "Printing Department"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.trim()
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(fn char ->
        case char do
          "." -> 0
          "@" -> 1
        end
      end)
    end)
    |> Nx.tensor(names: [:y, :x])
  end

  defp solve_1(diagram) do
    forklift(diagram)
    |> elem(1)
  end

  defp solve_2(diagram) do
    do_solve_2(diagram)
  end

  defp do_solve_2(diagram, acc \\ 0) do
    {next_diagram, count} = forklift(diagram)

    if count == 0 do
      acc
    else
      do_solve_2(next_diagram, acc + count)
    end
  end

  defp forklift(diagram) do
    remove_diagram =
      diagram
      |> Nx.window_sum({3, 3}, padding: :same)
      |> Nx.less_equal(4)
      |> then(fn adj ->
        Nx.select(diagram, adj, 0)
      end)

    count =
      remove_diagram
      |> Nx.sum()
      |> Nx.to_number()

    next_diagram = Nx.subtract(diagram, remove_diagram)

    {next_diagram, count}
  end
end
