defmodule AdventOfCode.Y2015.D5 do
  use AdventOfCode.Puzzle, year: 2015, day: 5

  @impl true
  def title, do: "Doesn't He Have Intern-Elves For This?"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    input
    |> String.split()
  end

  defp solve_1(strings) do
    strings
    |> Enum.reduce(0, fn str, acc ->
      if has_vowels?(str) and has_multiple?(str) and is_not_whitelisted?(str) do
        acc + 1
      else
        acc
      end
    end)
  end

  defp solve_2(strings) do
    strings
    |> Enum.reduce(0, fn str, acc ->
      if has_recurrence?(str) and has_separation?(str) do
        acc + 1
      else
        acc
      end
    end)
  end

  defp has_vowels?(str), do: Regex.match?(~r/(?:.*[aeiou].*){3}/, str)
  defp has_multiple?(str), do: Regex.match?(~r/.*(.)\1.*/, str)
  defp is_not_whitelisted?(str), do: not Regex.match?(~r/.*(?:ab|cd|pq|xy).*/, str)

  defp has_recurrence?(str), do: Regex.match?(~r/.*(..).*\1.*/, str)
  defp has_separation?(str), do: Regex.match?(~r/.*(.).\1.*/, str)
end
