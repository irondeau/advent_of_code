defmodule AdventOfCode.Y2023.D14 do
  use AdventOfCode.Puzzle, year: 2023, day: 14

  @impl true
  def title, do: "Parabolic Reflector Dish"

  @impl true
  def solve(input) do
    :ets.new(:rock_cache, [:named_table])

    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&String.graphemes/1)
  end

  defp solve_1(rocks) do
    rocks
    |> tilt()
    |> weigh()
  end

  defp solve_2(original_rocks) do
    0..1_000_000_000
    |> Enum.reduce_while(original_rocks, fn i, prev_rocks ->
      rocks =
        prev_rocks
        |> tilt(:north)
        |> tilt(:west)
        |> tilt(:south)
        |> tilt(:east)

      case :ets.lookup(:rock_cache, rocks) do
        [{_rocks, j}] ->
          cycles = rem(1_000_000_000 - j, i - j) + j - 1

          rocks =
            0..cycles
            |> Enum.reduce(original_rocks, fn _, rocks ->
              rocks
              |> tilt(:north)
              |> tilt(:west)
              |> tilt(:south)
              |> tilt(:east)
            end)

          {:halt, rocks}

        [] ->
          :ets.insert(:rock_cache, {rocks, i})
          {:cont, rocks}
      end
    end)
    |> weigh()
  end

  defp tilt(rocks, direction \\ :north) do
    case direction do
      :north ->
        rocks
        |> flip()
        |> Enum.map(&Enum.reverse/1)
        |> tilt_east()
        |> Enum.map(&Enum.reverse/1)
        |> flip()

      :east ->
        tilt_east(rocks)

      :south ->
        rocks
        |> flip()
        |> tilt_east()
        |> flip()

      :west ->
        rocks
        |> Enum.map(&Enum.reverse/1)
        |> tilt_east()
        |> Enum.map(&Enum.reverse/1)
    end
  end

  defp tilt_east(rocks) do
    rocks
    |> Enum.map(fn beam ->
      beam
      |> Enum.reduce([[]], fn object, [stack | rest] ->
        case object do
          "." ->
            [List.insert_at(stack, -1, ".") | rest]

          "O" ->
            [["O" | stack] | rest]

          "#" ->
            [[] | [["#" | stack] | rest]]
        end
      end)
      |> List.flatten()
      |> Enum.reverse()
    end)
  end

  defp weigh(rocks) do
    rocks
    |> Enum.with_index()
    |> Enum.map(fn {beam, i} ->
      beam
      |> Enum.count(&(&1 == "O"))
      |> Kernel.*(length(rocks) - i)
    end)
    |> Enum.sum()
  end

  defp flip(rocks) do
    rocks
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
