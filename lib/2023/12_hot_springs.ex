defmodule AdventOfCode.Y2023.D12 do
  use AdventOfCode.Puzzle, year: 2023, day: 12

  @impl true
  def title, do: "Hot Springs"

  @impl true
  def solve(input) do
    :ets.new(:position_cache, [:named_table])

    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      [field, springs] = String.split(line)

      {
        field,
        String.split(springs, ",") |> Enum.map(&String.to_integer/1)
      }
    end)
  end

  defp solve_1(input) do
    input
    |> Enum.map(fn {field, springs} ->
      :ets.delete_all_objects(:position_cache)
      arrangements(field, springs)
    end)
    |> Enum.sum()
  end

  defp solve_2(input) do
    input
    |> Enum.map(fn {field, springs} ->
      :ets.delete_all_objects(:position_cache)
      field = field <> "?" <> field <> "?" <> field <> "?" <> field <> "?" <> field
      springs = springs |> List.duplicate(5) |> List.flatten()
      arrangements(String.trim_trailing(field, "."), springs)
    end)
    |> Enum.sum()
  end

  defp arrangements(field, springs, {f_index, s_index, length} = position \\ {0, 0, 0}) do
    case :ets.lookup(:position_cache, position) do
      [{_position, result}] ->
        result

      _ ->
        if f_index == String.length(field) do
          cond do
            s_index == length(springs) and length == 0 -> 1
            s_index == length(springs) - 1 and Enum.at(springs, s_index) == length -> 1
            true -> 0
          end
        else
          result =
            Enum.reduce([".", "#"], 0, fn char, result ->
              if Enum.at(String.graphemes(field), f_index) in [char, "?"] do
                cond do
                  char == "#" ->
                    result + arrangements(field, springs, {f_index + 1, s_index, length + 1})

                  length == 0 ->
                    result + arrangements(field, springs, {f_index + 1, s_index, length})

                  s_index < String.length(field) and Enum.at(springs, s_index) == length ->
                    result + arrangements(field, springs, {f_index + 1, s_index + 1, 0})

                  true ->
                    result
                end
              else
                result
              end
            end)

          :ets.insert(:position_cache, {position, result})
          result
        end
    end
  end
end
