defmodule AdventOfCode.Y2023.D24 do
  use AdventOfCode.Puzzle, year: 2023, day: 24

  import IEx

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

    {hailstones, min, max}
  end

  defp solve_1({hailstones, min, max}) do
    hailstones
    |> Enum.map(&point_slope_form/1)
    |> collisions(min, max)
    |> MapSet.size()
    |> div(2)
  end

  defp solve_2(_input) do
    nil
  end

  defp collisions(hailstones, min, max, collisions \\ MapSet.new())
  defp collisions([], _min, _max, collisions), do: collisions

  defp collisions([h1 | hailstones], min, max, collisions) do
    h2 =
      hailstones
      |> Enum.find(fn {m, x, y} = h2 ->
        case intersect([h1, h2]) do
          nil ->
            false

          x_intersect ->
            y_intersect = m * (x_intersect - x) + y

            x_intersect >= min and
              x_intersect <= max and
              y_intersect >= min and
              y_intersect <= max
        end
      end)

    if h2 == nil do
      collisions(hailstones, min, max, collisions)
    else
      collisions(hailstones |> List.delete(h2), min, max, MapSet.union(collisions, MapSet.new([h1, h2])))
    end
  end

  defp intersect([{m1, x1, y1}, {m2, x2, y2}]) do
    if m1 == m2 do
      nil
    else
      (x1 * m1 - x2 * m2 + y2 - y1) / (m1 - m2)
    end
  end

  defp point_slope_form([{px, py, _pz}, {vx, vy, _vz}], opts \\ []) do
    if Keyword.get(opts, :dim) == 3 do
      nil
    else
      {vy / vx, px, py}
    end
  end
end
