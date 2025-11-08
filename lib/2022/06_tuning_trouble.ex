defmodule AdventOfCode.Y2022.D6 do
  use AdventOfCode.Puzzle, year: 2022, day: 6

  @impl true
  def title, do: "Tuning Trouble"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.graphemes()
  end

  defp solve_1(buffer) do
    find_message(buffer, 4)
  end

  defp solve_2(buffer) do
    find_message(buffer, 14)
  end

  defp find_message(buffer, len) do
    buffer
    |> Enum.chunk_every(len, 1)
    |> Enum.map(&Enum.uniq/1)
    |> Enum.with_index(len)
    |> Enum.find(fn {window, _index} ->
      length(window) == len
    end)
    |> elem(1)
  end
end
