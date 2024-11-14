defmodule AdventOfCode.Y2015.D14 do
  use AdventOfCode.Puzzle, year: 2015, day: 14

  @time 2503

  @impl true
  def title, do: "Reindeer Olympics"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      Regex.named_captures(~r/(?<name>\w+) can fly (?<speed>\d+) km\/s for (?<duration>\d+) seconds, but then must rest for (?<rest>\d+) seconds./, line)
      |> update_in(["speed"], &String.to_integer/1)
      |> update_in(["duration"], &String.to_integer/1)
      |> update_in(["rest"], &String.to_integer/1)
    end)
  end

  defp solve_1(herd) do
    herd
    |> Enum.map(&distance/1)
    |> Enum.max()
  end

  defp solve_2(herd) do
    for time <- 1..@time do
      Enum.max_by(herd, &distance(&1, time))
    end
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.max()
  end

  defp distance(reindeer, time \\ @time) do
    q = div(time, reindeer["duration"] + reindeer["rest"])
    r = rem(time, reindeer["duration"] + reindeer["rest"])
    (q * reindeer["duration"] + min(r, reindeer["duration"])) * reindeer["speed"]
  end
end
