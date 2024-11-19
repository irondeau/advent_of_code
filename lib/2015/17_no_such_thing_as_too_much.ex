defmodule AdventOfCode.Y2015.D17 do
  use AdventOfCode.Puzzle, year: 2015, day: 17

  @volume 150

  @impl true
  def title, do: "No Such Thing as Too Much"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp solve_1(containers) do
    fill_containers(containers)
    |> Enum.count()
  end

  defp solve_2(containers) do
    fill_containers(containers)
    |> Enum.group_by(&length/1)
    |> Enum.sort_by(& elem(&1, 0))
    |> hd()
    |> elem(1)
    |> length()
  end

  defp fill_containers(containers, volume \\ @volume, filled \\ [], acc \\ []) do
    cond do
      volume == 0 ->
        [filled | acc]
      Enum.empty?(containers) or volume < 0 ->
        acc
      true ->
        0..(length(containers) - 1)
        |> Enum.reduce(acc, fn index, acc ->
          next_container = Enum.fetch!(containers, index)
          containers = Enum.slice(containers, (index + 1)..-1)
          fill_containers(containers, volume - next_container, [next_container | filled], acc)
        end)
    end
  end
end
