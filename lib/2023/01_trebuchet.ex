defmodule AdventOfCode.Y2023.D1 do
  use AdventOfCode.Puzzle, year: 2023, day: 1

  @impl true
  def title, do: "Trebuchet?!"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    String.split(input, ~r/\R/)
  end

  defp solve_1(input, opts \\ [alphanumeric: false]) do
    input
    |> Enum.reduce(0, fn line, acc ->
      digits = get_digits(line, opts)
      acc + List.first(digits) * 10 + List.last(digits)
    end)
  end

  defp solve_2(input) do
    solve_1(input, alphanumeric: true)
  end

  defp get_digits(line, alphanumeric: true) do
    line
    |> Stream.unfold(fn
      "" -> nil
      str -> {str, String.slice(str, 1..-1//1)}
    end)
    |> Enum.reduce([], fn slice, acc ->
      case to_digit(slice) do
        n when is_integer(n) -> [n | acc]
        nil -> acc
      end
    end)
    |> Enum.reverse()
  end

  defp get_digits(line, alphanumeric: false) do
    Regex.scan(~r/\d/, line)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  defp to_digit("one" <> _), do: 1
  defp to_digit("two" <> _), do: 2
  defp to_digit("three" <> _), do: 3
  defp to_digit("four" <> _), do: 4
  defp to_digit("five" <> _), do: 5
  defp to_digit("six" <> _), do: 6
  defp to_digit("seven" <> _), do: 7
  defp to_digit("eight" <> _), do: 8
  defp to_digit("nine" <> _), do: 9
  defp to_digit(<<c>> <> _) when c in ?0..?9, do: String.to_integer(<<c>>)
  defp to_digit(_), do: nil
end
