defmodule AdventOfCode.Y2023.D24 do
  use AdventOfCode.Puzzle, year: 2023, day: 24

  @impl true
  def title, do: "Never Tell Me The Odds"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
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

  defp solve_2({hailstones, _min, _max}) do
    hs =
      [:a, :b, :c]
      |> Enum.zip(Enum.take(hailstones, 3))
      |> Enum.into(%{})

    a =
      [
        [
          -(hs.a.dy - hs.b.dy),
          hs.a.dx - hs.b.dx,
          0,
          hs.a.y - hs.b.y,
          -(hs.a.x - hs.b.x),
          0
        ],
        [
          -(hs.a.dy - hs.c.dy),
          hs.a.dx - hs.c.dx,
          0,
          hs.a.y - hs.c.y,
          -(hs.a.x - hs.c.x),
          0
        ],
        [
          0,
          -(hs.a.dz - hs.b.dz),
          hs.a.dy - hs.b.dy,
          0,
          hs.a.z - hs.b.z,
          -(hs.a.y - hs.b.y)
        ],
        [
          0,
          -(hs.a.dz - hs.c.dz),
          hs.a.dy - hs.c.dy,
          0,
          hs.a.z - hs.c.z,
          -(hs.a.y - hs.c.y)
        ],
        [
          -(hs.a.dz - hs.b.dz),
          0,
          hs.a.dx - hs.b.dx,
          hs.a.z - hs.b.z,
          0,
          -(hs.a.x - hs.b.x)
        ],
        [
          -(hs.a.dz - hs.c.dz),
          0,
          hs.a.dx - hs.c.dx,
          hs.a.z - hs.c.z,
          0,
          -(hs.a.x - hs.c.x)
        ]
      ]
      |> Nx.tensor()

    b =
      [
        (hs.a.y * hs.a.dx - hs.b.y * hs.b.dx) - (hs.a.x * hs.a.dy - hs.b.x * hs.b.dy),
        (hs.a.y * hs.a.dx - hs.c.y * hs.c.dx) - (hs.a.x * hs.a.dy - hs.c.x * hs.c.dy),
        (hs.a.z * hs.a.dy - hs.b.z * hs.b.dy) - (hs.a.y * hs.a.dz - hs.b.y * hs.b.dz),
        (hs.a.z * hs.a.dy - hs.c.z * hs.c.dy) - (hs.a.y * hs.a.dz - hs.c.y * hs.c.dz),
        (hs.a.z * hs.a.dx - hs.b.z * hs.b.dx) - (hs.a.x * hs.a.dz - hs.b.x * hs.b.dz),
        (hs.a.z * hs.a.dx - hs.c.z * hs.c.dx) - (hs.a.x * hs.a.dz - hs.c.x * hs.c.dz)
      ]
      |> Nx.tensor()

    [x, y, z, _dx, _dy, _dz] =
      Nx.LinAlg.solve(a, b)
      |> Nx.to_list()

    round(x + y + z)
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
