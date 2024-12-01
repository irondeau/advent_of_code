defmodule AdventOfCode.Y2024.D1 do
  use AdventOfCode.Puzzle, year: 2024, day: 1

  @impl true
  def title, do: "Historian Hysteria"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.zip_with(&Function.identity/1)
  end

  defp solve_1(lists) do
    [l1, l2] =
      lists
      |> Enum.map(fn list ->
        list
        |> Enum.sort(:asc)
        |> Nx.tensor()
      end)

    Nx.subtract(l1, l2)
    |> Nx.abs()
    |> Nx.sum()
    |> Nx.to_number()
  end

  defp solve_2([l1, l2]) do
    freq = Enum.frequencies(l2)

    for n <- l1 do
      n * (freq[n] || 0)
    end
    |> Enum.sum()
  end
end
