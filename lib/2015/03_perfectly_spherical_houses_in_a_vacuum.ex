defmodule AdventOfCode.Y2015.D3 do
  use AdventOfCode.Puzzle, year: 2015, day: 3

  @start [0, 0]

  @impl true
  def title, do: "Perfectly Spherical Houses In A Vacuum"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.graphemes()
  end

  defp solve_1(graphemes) do
    graphemes
    |> deliver_present(@start, MapSet.new([@start]))
    |> MapSet.size()
  end

  defp solve_2(graphemes) do
    graphemes
    |> Enum.with_index()
    |> Enum.group_by(
      fn {_char, idx} -> rem(idx, 2) end,
      fn {char, _idx} -> char end
    )
    |> Map.values()
    |> Enum.map(fn chars -> deliver_present(chars, @start, MapSet.new([@start])) end)
    |> then(&combine_jobs/1)
    |> MapSet.size()
  end

  defp deliver_present([], _, house_set), do: house_set

  defp deliver_present([dir | dir_tail], pos, house_set) do
    next_pos = next_pos(dir, pos)
    deliver_present(dir_tail, next_pos, MapSet.put(house_set, next_pos))
  end

  defp next_pos("^", [x, y]), do: [x, y + 1]
  defp next_pos(">", [x, y]), do: [x + 1, y]
  defp next_pos("v", [x, y]), do: [x, y - 1]
  defp next_pos("<", [x, y]), do: [x - 1, y]

  defp combine_jobs([santa | []]), do: santa
  defp combine_jobs([santa | [robo_santa]]), do: MapSet.union(santa, robo_santa)
end
