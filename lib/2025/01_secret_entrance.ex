defmodule AdventOfCode.Y2025.D1 do
  use AdventOfCode.Puzzle, year: 2025, day: 1

  @dial_size 100
  @starting_pos 50

  @impl true
  def title, do: "Secret Entrance"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.trim()
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      {dir, count} = String.split_at(line, 1)
      {dir, String.to_integer(count)}
    end)
  end

  defp solve_1(instrs) do
    instrs
    |> crack()
    |> Enum.filter(&(&1 == 0))
    |> Enum.count()
  end

  defp solve_2(instrs) do
    crack_2(instrs)
  end

  defp crack(instrs, positions \\ [@starting_pos])

  defp crack([], positions), do: positions

  defp crack([{"L", amt} | rest], positions) do
    current_pos = hd(positions)
    next_pos = (current_pos - amt) |> Integer.mod(@dial_size)
    crack(rest, [next_pos | positions])
  end

  defp crack([{"R", amt} | rest], positions) do
    current_pos = hd(positions)
    next_pos = (current_pos + amt) |> Integer.mod(@dial_size)
    crack(rest, [next_pos | positions])
  end

  defp crack_2(instrs, current_pos \\ @starting_pos, count \\ 0)

  defp crack_2([], _current_pos, count), do: count

  defp crack_2([{"L", amt} | rest], current_pos, count) do
    theoretical_pos = current_pos - amt
    next_pos = Integer.mod(theoretical_pos, @dial_size)

    count =
      for pos <- Range.new(current_pos - 1, theoretical_pos, -1),
          Integer.mod(pos, @dial_size) == 0,
          reduce: count do
        acc -> acc + 1
      end

    crack_2(rest, next_pos, count)
  end

  defp crack_2([{"R", amt} | rest], current_pos, count) do
    theoretical_pos = current_pos + amt
    next_pos = Integer.mod(theoretical_pos, @dial_size)

    count =
      for pos <- Range.new(current_pos + 1, theoretical_pos, 1),
          Integer.mod(pos, @dial_size) == 0,
          reduce: count do
        acc -> acc + 1
      end

    crack_2(rest, next_pos, count)
  end
end
