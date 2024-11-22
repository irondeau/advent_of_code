defmodule AdventOfCode.Y2015.D20 do
  use AdventOfCode.Puzzle, year: 2015, day: 20

  alias AdventOfCode.Helpers.Math

  @impl true
  def title, do: "Infinite Elves and Infinite Houses"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  defdelegate parse(input), to: String, as: :to_integer

  defp solve_1(presents) do
    1..presents
    |> Enum.find(fn i ->
      Math.divisors(i)
      |> Nx.tensor()
      |> Nx.multiply(10)
      |> Nx.sum()
      |> Nx.to_number()
      |> Kernel.>=(presents)
    end)
  end

  defp solve_2(presents) do
    1..presents
    |> Enum.find(fn i ->
      Math.divisors(i)
      |> Enum.filter(fn divisor -> div(i, divisor) <= 50 end)
      |> Nx.tensor()
      |> Nx.multiply(11)
      |> Nx.sum()
      |> Nx.to_number()
      |> Kernel.>=(presents)
    end)
  end
end
