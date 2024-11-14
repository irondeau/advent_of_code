defmodule AdventOfCode.Y2023.D15 do
  use AdventOfCode.Puzzle, year: 2023, day: 15

  @impl true
  def title, do: "Lens Library"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(",")
  end

  defp solve_1(input) do
    input
    |> Enum.map(fn step ->
      hash(step)
    end)
    |> Enum.sum()
  end

  defp solve_2(input) do
    Enum.map(input, fn step ->
      Regex.split(~r/[=-]/, step, include_captures: true, trim: true)
    end)
    |> initialize()
    |> power()
  end

  def hash(string, acc \\ 0)

  def hash("", acc), do: acc

  def hash(<<c>> <> rest, acc) do
    acc = rem((acc + c) * 17, 256)
    hash(rest, acc)
  end

  defp initialize(sequence) do
    sequence
    |> Enum.reduce(%{}, fn step, boxes ->
      case step do
        [label, "=", lens] ->
          box = hash(label)
          value = {label, String.to_integer(lens)}

          # update existing value if exists, else put new value
          Map.update(boxes, box, [value], fn lenses ->
            i = Enum.find_index(lenses, fn {old_label, _lens} -> old_label == label end)

            if i do
              List.replace_at(lenses, i, value)
            else
              [value | lenses]
            end
          end)

        [label, "-"] ->
          box = hash(label)

          Map.update(boxes, box, [], fn lenses ->
            lenses
            |> Enum.reject(fn {old_label, _lens} ->
              old_label == label
            end)
          end)
      end
    end)
  end

  defp power(initialized_sequence) do
    initialized_sequence
    |> Map.to_list()
    |> Enum.sort_by(&(elem(&1, 0)))
    |> Enum.map(fn {box, lenses} ->
      lenses
      |> Enum.reverse()
      |> Enum.with_index(1)
      |> Enum.map(fn {{_label, lens}, i} ->
        (box + 1) * i * lens
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end
end
