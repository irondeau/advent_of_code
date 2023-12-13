defmodule AdventOfCode.Y2023.D13 do
  use AdventOfCode.Puzzle, year: 2023, day: 13

  @impl true
  def title, do: "Point Of Incidence"

  @impl true
  def solve(input) do
    input
    |> then(&{solve_1(&1), solve_2(&1)})
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R\R/)
    |> Enum.map(fn pattern ->
      pattern
      |> String.split(~r/\R/)
      |> Enum.map(&String.graphemes/1)
    end)
  end

  defp solve_1(input) do
    input
    |> Enum.map(fn pattern ->
      horizontal_symmetry = get_symmetry(pattern)

      mirrors =
        if match?(%MapSet{}, horizontal_symmetry) do
          MapSet.to_list(horizontal_symmetry)
        end

      if mirrors != nil and not Enum.empty?(mirrors) and match?([_], mirrors) do
        hd(mirrors)
      else
        pattern
        |> flip()
        |> get_symmetry()
        |> MapSet.to_list()
        |> hd()
        |> Kernel.*(100)
      end
    end)
    |> Enum.sum()
  end

  defp solve_2(_input) do
    nil
  end

  defp get_symmetry(pattern) do
    tl(pattern)
    |> Enum.reduce_while(hd(pattern) |> get_mirrors(), fn line, mirrors ->
      if MapSet.size(mirrors) == 0 do
        {:halt, nil}
      else
        {:cont,
          line
          |> get_mirrors()
          |> MapSet.intersection(mirrors)}
      end
    end)
  end

  defp get_mirrors(line) do
    line
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.with_index()
    |> Enum.filter(fn {[a, b], i} ->
      if a == b do
        line
        |> Enum.split(i + 1)
        |> then(fn {first, last} -> Enum.reverse(first) |> Enum.zip(last) end)
        |> Enum.all?(fn {m, n} -> m == n end)
      else
        false
      end
    end)
    |> Enum.map(&(elem(&1, 1) + 1))
    |> MapSet.new()
  end

  defp flip(pattern) do
    pattern
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
