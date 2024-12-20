defmodule AdventOfCode.Y2024.D20 do
  use AdventOfCode.Puzzle, year: 2024, day: 20

  @timesave 100
  @max_cheat_1 2
  @max_cheat_2 20

  @impl true
  def title, do: "Race Condition"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    {vs, start} =
      input
      |> String.split(~r/\R/)
      |> Enum.with_index()
      |> Enum.reduce({MapSet.new(), nil}, fn {line, y}, {vs, start} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce({vs, start}, fn
          {"#", _x}, {vs, start} -> {vs, start}
          {"S", x}, {vs, _start} -> {MapSet.put(vs, {x, y}), {x, y}}
          {_char, x}, {vs, start} -> {MapSet.put(vs, {x, y}), start}
        end)
      end)

    weight_track(vs, start)
  end

  defp solve_1(track) do
    race(track, @max_cheat_1)
  end

  defp solve_2(track) do
    race(track, @max_cheat_2)
  end

  defp race(track, max_cheat) do
    for {v1, w1} <- track,
        {v2, w2} <- track,
        v1 != v2,
        w2 > w1,
        d = cheat_distance(v1, v2),
        d <= max_cheat,
        w2 - w1 - d >= @timesave,
        reduce: 0 do
      acc -> acc + 1
    end
  end

  defp weight_track(vs, v, distance \\ 0, track \\ %{}) do
    track = Map.put(track, v, distance)

    adjacent(v)
    |> Enum.filter(&MapSet.member?(vs, &1))
    |> Enum.reject(&Map.has_key?(track, &1))
    |> Enum.reduce(track, fn next, track ->
      weight_track(vs, next, distance + 1, track)
    end)
  end

  defp adjacent({x, y}),
    do: [
      {x, y - 1},
      {x + 1, y},
      {x, y + 1},
      {x - 1, y}
    ]

  defp cheat_distance({x1, y1}, {x2, y2}),
    do: abs(y2 - y1) + abs(x2 - x1)
end
