defmodule AdventOfCode.Y2023.D22 do
  use AdventOfCode.Puzzle, year: 2023, day: 22

  @impl true
  def title, do: "Sand Slabs"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.reduce([], fn line, bricks ->
      [[x1, y1, z1], [x2, y2, z2]] =
        line
        |> String.split("~")
        |> Enum.map(fn coord ->
          coord
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)
        end)

      brick =
        for z <- z1..z2, y <- y1..y2, x <- x1..x2 do
          {x, y, z}
        end

      [brick | bricks]
    end)
    |> sort()
  end

  defp solve_1(bricks) do
    {_, bricks_fallen} = fall(bricks)

    bricks_fallen
    |> Enum.map(fn brick ->
      List.delete(bricks_fallen, brick) |> fall() |> elem(0)
    end)
    |> Enum.count(&(&1 == 0))
  end

  defp solve_2(bricks) do
    {_, bricks_fallen} = fall(bricks)

    bricks_fallen
    |> Enum.map(fn brick ->
      List.delete(bricks_fallen, brick) |> fall() |> elem(0)
    end)
    |> Enum.sum()
  end

  defp sort(bricks) do
    bricks
    |> Enum.sort_by(fn brick ->
      brick
      |> Enum.map(&elem(&1, 2))
      |> Enum.min()
    end)
  end

  def bottom(brick) do
    z_min =
      brick
      |> Enum.map(&elem(&1, 2))
      |> Enum.min()

    brick
    |> Enum.filter(fn {_x, _y, z} ->
      z == z_min
    end)
  end

  def fall(bricks, z_levels \\ %{}, bricks_fallen \\ [], count \\ 0)

  def fall([], _, bricks_fallen, count), do: {count, bricks_fallen |> sort()}

  def fall([brick | bricks], z_levels, bricks_fallen, count) do
    fall_distance =
      brick
      |> bottom()
      |> Enum.map(fn {x, y, z} ->
        z - Map.get(z_levels, {x, y}, 0) - 1
      end)
      |> Enum.min()

    brick = Enum.map(brick, fn {x, y, z} -> {x, y, z - fall_distance} end)

    z_levels =
      brick
      |> Enum.reduce(z_levels, fn {x, y, z}, z_levels ->
        Map.put(z_levels, {x, y}, z)
      end)

    fall(bricks, z_levels, [brick | bricks_fallen], count + min(fall_distance, 1))
  end
end
