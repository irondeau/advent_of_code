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
    input
    |> String.split("\n")
  end

  defp solve_1(input) do
    input
    |> Enum.reduce(0, fn line, acc ->
      digits = get_digits(line)
      acc + List.first(digits) * 10 + List.last(digits)
    end)
  end

  defp solve_2(input) do
    input
    |> Enum.reduce(0, fn line, acc ->
      digits = get_digits(line, alphanumeric: true)
      acc + List.first(digits) * 10 + List.last(digits)
    end)
  end

  defp get_digits(line, opts \\ [alphanumeric: false])

  defp get_digits(line, alphanumeric: true) do
    Enum.reduce(0..(String.length(line) - 1), [], fn i, acc ->
      slice = String.slice(line, i..-1)

      case to_digit(slice) do
        integer when is_integer(integer) ->
          [integer | acc]

        nil ->
          char = String.at(slice, 0)

          if String.match?(char, ~r/\d/) do
            [String.to_integer(char) | acc]
          else
            acc
          end
      end
    end)
    |> Enum.reverse()
  end

  defp get_digits(line, alphanumeric: false) do
    line
    |> String.graphemes()
    |> Enum.reduce([], fn char, acc ->
      if String.match?(char, ~r/\d/) do
        [String.to_integer(char) | acc]
      else
        acc
      end
    end)
    |> Enum.reverse()
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
  defp to_digit(_), do: nil
end
