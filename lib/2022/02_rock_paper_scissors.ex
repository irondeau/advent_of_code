defmodule AdventOfCode.Y2022.D2 do
  use AdventOfCode.Puzzle, year: 2022, day: 2

  @rock_paper_scissors [
    {:rock, :rock, :draw},
    {:rock, :paper, :win},
    {:rock, :scissors, :lose},
    {:paper, :rock, :lose},
    {:paper, :paper, :draw},
    {:paper, :scissors, :win},
    {:scissors, :rock, :win},
    {:scissors, :paper, :lose},
    {:scissors, :scissors, :draw}
  ]

  @impl true
  def title, do: "Rock Paper Scissors"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.trim()
    |> String.split(~r/\R/)
    |> Enum.map(fn round ->
      round
      |> String.split(" ")
    end)
  end

  defp solve_1(strategies) do
    strategies
    |> Enum.map(fn round ->
      round
      |> Enum.map(&decode_1/1)
      |> List.to_tuple()
      |> resolve_1()
    end)
    |> score()
  end

  defp solve_2(strategies) do
    strategies
    |> Enum.map(fn round ->
      round
      |> Enum.map(&decode_2/1)
      |> List.to_tuple()
      |> resolve_2()
    end)
    |> score()
  end

  defp decode_1(str) when str in ["A", "X"], do: :rock
  defp decode_1(str) when str in ["B", "Y"], do: :paper
  defp decode_1(str) when str in ["C", "Z"], do: :scissors

  defp decode_2("A"), do: :rock
  defp decode_2("B"), do: :paper
  defp decode_2("C"), do: :scissors
  defp decode_2("X"), do: :lose
  defp decode_2("Y"), do: :draw
  defp decode_2("Z"), do: :win

  defp resolve_1({opponent, player}) do
    Enum.find(@rock_paper_scissors, fn strategy ->
      match?({^opponent, ^player, _}, strategy)
    end)
  end

  defp resolve_2({opponent, result}) do
    Enum.find(@rock_paper_scissors, fn strategy ->
      match?({^opponent, _, ^result}, strategy)
    end)
  end

  defp score(strategy) when is_list(strategy) do
    strategy
    |> Enum.map(fn round ->
      score_round(round) + score_shape(round)
    end)
    |> Enum.sum()
  end

  defp score_round({_, _, :win}), do: 6
  defp score_round({_, _, :draw}), do: 3
  defp score_round({_, _, :lose}), do: 0

  defp score_shape({_, :rock, _}), do: 1
  defp score_shape({_, :paper, _}), do: 2
  defp score_shape({_, :scissors, _}), do: 3
end
