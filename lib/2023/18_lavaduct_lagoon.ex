defmodule AdventOfCode.Y2023.D18 do
  use AdventOfCode.Puzzle, year: 2023, day: 18

  @instr_1 0
  @instr_2 1

  @impl true
  def title, do: "Lavaduct Lagoon"

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
      [direction_1, meters_1, color] = String.split(line)

      {meters_2, direction_2} =
        color
        |> String.replace(~r/[\(\)#]/, "")
        |> String.split_at(-1)

      instr_1 = {direction_1, String.to_integer(meters_1)}
      instr_2 = {Enum.at(~w/R D L U/, String.to_integer(direction_2)), String.to_integer(meters_2, 16)}

      {instr_1, instr_2}
    end)
  end

  defp solve_1(dig_plan) do
    solve_for(dig_plan, @instr_1)
  end

  defp solve_2(dig_plan) do
    solve_for(dig_plan, @instr_2)
  end

  defp solve_for(dig_plan, instr) do
    dig_plan = get_in(dig_plan, [Access.all(), Access.elem(instr)])

    shoelace_area =
      dig_plan
      |> corners()
      |> shoelace()

    perimeter_area =
      dig_plan
      |> get_in([Access.all(), Access.elem(1)])
      |> Enum.sum()

    shoelace_area + div(perimeter_area, 2) + 1
  end

  defp corners(dig_plan) do
    dig_plan
    |> Enum.reduce({[], [0, 0]}, fn {direction, meters}, {corners, [x, y]} ->
      position =
        case direction do
          "R" -> [x + meters, y]
          "D" -> [x, y + meters]
          "L" -> [x - meters, y]
          "U" -> [x, y - meters]
        end

      {[position | corners], position}
    end)
    |> elem(0)
  end

  defp shoelace(vertices) do
    vertices = vertices ++ [hd(vertices)]

    vertices
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [[x1, y1], [x2, y2]] ->
      x1 * y2 - x2 * y1
    end)
    |> Enum.sum()
    |> abs()
    |> div(2)
  end
end
