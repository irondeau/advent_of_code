defmodule AdventOfCode.Y2023.D24 do
  use AdventOfCode.Puzzle, year: 2023, day: 24

  @impl true
  def title, do: "Never Tell Me The Odds"

  @impl true
  def solve(input) do
    input
    |> then(&{solve_1(&1), solve_2(&1)})
  end

  @impl true
  def parse(input) do
    lines = String.split(input, ~r/\R/)

    [min, max] =
      hd(lines)
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    hailstones =
      tl(lines)
      |> Enum.map(fn line ->
        line
        |> String.split(~r/\s+@\s+/)
        |> Enum.map(fn coords ->
          coords
          |> String.split(~r/,\s+/)
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()
        end)
      end)
      |> Enum.map(fn [{x, y, z}, {dx, dy, dz}] ->
        %{
          x: x,
          y: y,
          z: z,
          dx: dx,
          dy: dy,
          dz: dz
        }
      end)

    {hailstones, min, max}
  end

  defp solve_1({hailstones, min, max}) do
    hailstones
    |> collisions(min, max)
    |> MapSet.size()
  end

  defp solve_2({_hailstones, _min, _max}) do
    nil
  end

  defp collisions(hailstones, min, max, collisions \\ MapSet.new())
  defp collisions([], _min, _max, collisions), do: collisions

  defp collisions([%{x: x1, y: y1, dx: dx1, dy: dy1} = h1 | hailstones], min, max, collisions) do
    collisions =
      hailstones
      |> Enum.reduce(collisions, fn %{x: x2, dx: dx2} = h2, collisions ->
        case intersect([h1, h2]) do
          nil ->
            collisions

          x_intersect ->
            m1 = dy1 / dx1
            y_intersect = m1 * (x_intersect - x1) + y1

            if x_intersect >= min and
                x_intersect <= max and
                y_intersect >= min and
                y_intersect <= max and
                dx1 > 0 == x_intersect > x1 and
                dx2 > 0 == x_intersect > x2 do
              MapSet.put(collisions, {h1, h2})
            else
              collisions
            end
        end
      end)

    collisions(hailstones, min, max, collisions)
  end

  defp intersect([%{x: x1, y: y1, dx: dx1, dy: dy1}, %{x: x2, y: y2, dx: dx2, dy: dy2}]) do
    m1 = dy1 / dx1
    m2 = dy2 / dx2

    if m1 == m2 do
      nil
    else
      (x1 * m1 - x2 * m2 + y2 - y1) / (m1 - m2)
    end
  end
end
