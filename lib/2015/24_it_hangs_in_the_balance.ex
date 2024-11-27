defmodule AdventOfCode.Y2015.D24 do
  use AdventOfCode.Puzzle, year: 2015, day: 24

  @impl true
  def title, do: "It Hangs in the Balance"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\W/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp solve_1(packages, group_count \\ 3) do
    group_sum = div(Enum.sum(packages), group_count)

    packages
    |> group(group_sum)
    |> Enum.sort_by(&length/1)
    |> then(fn list ->
      Enum.take_while(list, fn item -> length(item) == length(hd(list)) end)
    end)
    |> Enum.map(&Enum.product/1)
    |> Enum.min()
  end

  defp solve_2(packages) do
    solve_1(packages, 4)
  end

  defp group(_list, target_sum) when target_sum < 0, do: []
  defp group(_list, 0), do: [[]]

  defp group(list, target_sum) do
    list
    |> Stream.unfold(fn
      [] -> nil
      [hd | tl] -> {{hd, tl}, tl}
    end)
    |> Enum.flat_map(fn {value, sublist} ->
      sublist
      |> group(target_sum - value)
      |> Enum.map(& [value | &1])
    end)
  end
end
