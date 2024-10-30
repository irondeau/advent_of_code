defmodule AdventOfCode.Y2015.D11 do
  use AdventOfCode.Puzzle, year: 2015, day: 11

  @impl true
  def title, do: "Corporate Policy"

  @impl true
  def solve(input) do
    sol_1 = solve_1(input)
    {sol_1, solve_2(sol_1)}
  end

  @impl true
  def parse(input) do
    input
  end

  defp solve_1(input) do
    password = next(input)

    if valid?(password) do
      password
    else
      solve_1(password)
    end
  end

  defp solve_2(input) do
    solve_1(input)
  end

  defp next(password) when is_binary(password) do
    password
    |> String.graphemes()
    |> Enum.reverse()
    |> next([])
    |> Enum.join()
  end

  defp next(["z"], prefix), do: ["a", "a" | prefix]
  defp next([current], prefix), do: [next_char(current) | prefix]
  defp next([current | suffix], prefix) do
    current = next_char(current)

    if current == "a" do
      next(suffix, [current | prefix])
    else
      Enum.reduce(suffix, [current | prefix], fn c, prefix -> [c | prefix] end)
    end
  end

  defp next_char(char) do
    case char do
      "h" -> "j"
      "k" -> "m"
      "n" -> "p"
      "z" -> "a"
      <<c>> -> <<c + 1>>
    end
  end

  defp valid?(password) do
    has_straight?(password) && excludes_letters?(password) && has_two_pairs?(password)
  end

  defp has_straight?(password) do
    password
    |> String.to_charlist()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.any?(fn [a, b, c] -> c - b == 1 && b - a == 1 end)
  end

  defp excludes_letters?(password) do
    password
    |> String.graphemes()
    |> Enum.all?(fn letter -> letter not in ["i", "l", "o"] end)
  end

  defp has_two_pairs?(password) do
    password
    |> String.to_charlist()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [a, b] -> a == b end)
    |> Enum.uniq()
    |> then(fn pairs -> length(pairs) > 1 end)
  end
end
