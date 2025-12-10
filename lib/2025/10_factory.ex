defmodule AdventOfCode.Y2025.D10 do
  use AdventOfCode.Puzzle, year: 2025, day: 10

  import Bitwise
  alias AdventOfCode.Helpers

  @impl true
  def title, do: "Factory"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.trim()
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      Regex.named_captures(
        ~r/\[(?<lights>[\.#]+)\]\s(?<buttons>(\([\d,]+\)\s)+){(?<joltage>[\d,]+)}/,
        line
      )
      |> update_in([Access.key("lights")], &parse_lights/1)
      |> update_in([Access.key!("buttons")], &parse_buttons/1)
      |> update_in([Access.key!("joltage")], &parse_joltages/1)
    end)
  end

  defp parse_lights(lights) do
    lights
    |> String.to_charlist()
    |> Enum.map(fn
      ?. -> 0
      ?# -> 1
    end)
    |> Enum.reverse()
    |> Integer.undigits(2)
  end

  defp parse_buttons(buttons) do
    buttons
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(fn button ->
      button
      |> String.slice(1..-2//1)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(0, fn light, binary ->
        bor(binary, 1 <<< light)
      end)
    end)
  end

  defp parse_joltages(joltages) do
    joltages
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp solve_1(schematic) do
    schematic
    |> Enum.map(fn machine ->
      size = length(machine["buttons"])
      desired_state = machine["lights"]

      arities =
        for arity <- 1..size,
            buttons <- Helpers.Enum.combinations(machine["buttons"], arity),
            state = Enum.reduce(buttons, 0, &bxor/2),
            state == desired_state do
          arity
        end

      Enum.min(arities)
    end)
    |> Enum.sum()
  end

  defp solve_2(_input) do
    nil
  end
end
