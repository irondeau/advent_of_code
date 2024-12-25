defmodule AdventOfCode.Y2024.D25 do
  use AdventOfCode.Puzzle, year: 2024, day: 25

  @base_schematic Map.new(0..4, &{&1, 0})

  @impl true
  def title, do: "Code Chronicle"

  @impl true
  def solve({locks, keys}) do
    for key <- keys,
        lock <- locks,
        reduce: 0 do
      acc -> if fits?(key, lock), do: acc + 1, else: acc
    end
  end

  @impl true
  def parse(input) do
    {locks, keys} =
      input
      |> String.split(~r/\R\R/)
      |> Enum.split_with(&String.starts_with?(&1, "#"))

    {parse_schematics(locks), parse_schematics(keys)}
  end

  defp parse_schematics(schematics) do
    schematics
    |> Enum.map(fn schematic ->
      schematic
      |> String.split(~r/\R/)
      |> Enum.slice(1..5)
      |> Enum.reduce(@base_schematic, fn line, acc ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn
          {"#", x}, acc -> Map.update!(acc, x, &(&1 + 1))
          _, acc -> acc
        end)
      end)
    end)
  end

  defp fits?(key, lock) do
    Map.merge(key, lock, fn _k, tooth_height, pin_height ->
      tooth_height + pin_height <= 5
    end)
    |> Map.values()
    |> Enum.all?()
  end
end
