defmodule AdventOfCode.Y2023.D2 do
  use AdventOfCode.Puzzle, year: 2023, day: 2

  @max_color %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  @impl true
  def title, do: "Cube Conundrum"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      Regex.named_captures(~r/Game (?<id>\d+): (?<sets>.*)/, line)
      |> Enum.into(%{}, fn {k, v} ->
        if k == "id" do
          {k, String.to_integer(v)}
        else
          {k, parse_sets(v)}
        end
      end)
    end)
  end

  defp parse_sets(input) do
    input
    |> String.split(";")
    |> Enum.into([], fn set ->
      set
      |> String.split(",")
      |> Enum.into(%{}, fn cube ->
        Regex.named_captures(~r/(?<count>\d+) (?<color>\w+)/, cube)
        |> then(&({&1["color"], String.to_integer(&1["count"])}))
      end)
    end)
  end

  defp solve_1(input) do
    Enum.map(input, fn %{"id" => id, "sets" => sets} ->
      Enum.map(sets, fn set ->
        Enum.map(set, fn {color, count} ->
          @max_color[color] >= count
        end)
        |> Enum.all?()
      end)
      |> Enum.all?()
      |> case do
        true -> id
        false -> 0
      end
    end)
    |> Enum.sum()
  end

  defp solve_2(input) do
    Enum.map(input, fn %{"sets" => sets} ->
      Enum.reduce(sets, %{"red" => 0, "green" => 0, "blue" => 0}, fn set, acc ->
        Map.merge(acc, set, fn _k, v1, v2 -> max(v1, v2) end)
      end)
      |> Map.values()
      |> Enum.product()
    end)
    |> Enum.sum()
  end
end
