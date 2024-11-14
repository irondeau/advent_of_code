defmodule AdventOfCode.Y2015.D4 do
  use AdventOfCode.Puzzle, year: 2015, day: 4

  @impl true
  def title, do: "The Ideal Stocking Stuffer"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  defp solve_1(key) do
    satisfy(key, nil, 1)
  end

  defp solve_2(key) do
    satisfy2(key, nil, 1)
  end

  defp satisfy(_str, "00000" <> _, n), do: n - 1
  defp satisfy(str, _hash, n), do: satisfy(str, hash(str <> Integer.to_string(n)), n + 1)

  defp satisfy2(_str, "000000" <> _, n), do: n - 1
  defp satisfy2(str, _hash, n), do: satisfy2(str, hash(str <> Integer.to_string(n)), n + 1)

  defp hash(str), do: :crypto.hash(:md5, str) |> Base.encode16()
end
