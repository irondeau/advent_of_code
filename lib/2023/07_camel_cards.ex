defmodule AdventOfCode.Y2023.D7 do
  use AdventOfCode.Puzzle, year: 2023, day: 7

  @card_rank_1 ~w/2 3 4 5 6 7 8 9 T J Q K A/
  @card_rank_2 ~w/J 2 3 4 5 6 7 8 9 T Q K A/

  @impl true
  def title, do: "Camel Cards"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line)
      {String.graphemes(hand), String.to_integer(bid)}
    end)
  end

  defp solve_1(input) do
    input
    |> Enum.map(fn {hand, bid} -> {{hand, bid}, score_hand_1(hand)} end)
    |> Enum.sort(&compare_hands/2)
    |> Enum.map(fn {{hand, bid}, _} -> {hand, bid} end)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {{_hand, bid}, index} -> bid * index end)
    |> Enum.sum()
  end

  defp solve_2(input) do
    input
    |> Enum.map(fn {hand, bid} -> {{hand, bid}, score_hand_2(hand)} end)
    |> Enum.sort(&compare_hands/2)
    |> Enum.map(fn {{hand, bid}, _} -> {hand, bid} end)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {{_hand, bid}, index} -> bid * index end)
    |> Enum.sum()
  end

  defp compare_hands({_, score1}, {_, score2}) do
    Enum.zip(score1, score2)
    |> Enum.find(fn {a, b} -> a != b end)
    |> then(fn {a, b} -> a > b end)
  end

  defp score_hand_1(hand) do
    hand_freq = Enum.frequencies(hand)
    hand_values = Enum.map(hand, fn card -> Enum.find_index(@card_rank_1, &(&1 == card)) end)

    hand_score =
      case Map.values(hand_freq) |> Enum.sort() do
        [5] -> 7
        [1, 4] -> 6
        [2, 3] -> 5
        [1, 1, 3] -> 4
        [1, 2, 2] -> 3
        [1, 1, 1, 2] -> 2
        [1, 1, 1, 1, 1] -> 1
      end

    [hand_score | hand_values]
  end

  defp score_hand_2(hand) do
    hand_values = Enum.map(hand, fn card -> Enum.find_index(@card_rank_2, &(&1 == card)) end)

    hand_freq =
      hand
      |> Enum.frequencies()
      |> Map.pop("J")
      |> case do
        {nil, hand_freq} -> hand_freq
        {joker_count, hand_freq} ->
          hand_freq
          |> Map.to_list()
          |> Enum.sort(fn {suit1, count1}, {suit2, count2} ->
            if count1 == count2 do
              suit1 > suit2
            else
              count1 > count2
            end
          end)
          |> Enum.take(1)
          |> case do
            [] -> %{Enum.find_index(@card_rank_2, &(&1 == "A")) => 5}
            [{suit, count}] -> Map.put(hand_freq, suit, count + joker_count)
          end
      end

    hand_score =
      case Map.values(hand_freq) |> Enum.sort() do
        [5] -> 7
        [1, 4] -> 6
        [2, 3] -> 5
        [1, 1, 3] -> 4
        [1, 2, 2] -> 3
        [1, 1, 1, 2] -> 2
        [1, 1, 1, 1, 1] -> 1
      end

    [hand_score | hand_values]
  end
end
