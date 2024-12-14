defmodule AdventOfCode.Y2024.D14 do
  use AdventOfCode.Puzzle, year: 2024, day: 14

  alias AdventOfCode.Helpers

  @impl true
  def title, do: "Restroom Redoubt"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    [room, robots] = String.split(input, ~r/\R/, parts: 2)

    room =
      room
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    robots =
      robots
      |> String.split(~r/\R/)
      |> Enum.map(fn line ->
        line
        |> String.split(["p=", ",", " v="], trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk_every(2)
        |> Enum.zip_reduce([:p, :v], %{}, fn value, key, map ->
          Map.put(map, key, List.to_tuple(value))
        end)
      end)

    {robots, room}
  end

  defp solve_1({robots, {rx, ry}}) do
    robots
    |> Enum.map(fn %{p: {px, py}, v: {vx, vy}} ->
      {
        Integer.mod(px + vx * 100, rx),
        Integer.mod(py + vy * 100, ry)
      }
    end)
    |> Enum.reject(fn {x, y} -> x == div(rx, 2) or y == div(ry, 2) end)
    |> Enum.group_by(fn {x, y} -> {round(x / rx), round(y / ry)} end)
    |> Map.values()
    |> Enum.map(&Enum.count/1)
    |> Enum.product()
  end

  defp solve_2({robots, room}) do
    Enum.reduce_while(0..10_000, robots, fn index, robots ->
      robot_positions = get_in(robots, [Access.all(), Access.key!(:p)])

      if not Helpers.List.duplicate?(robot_positions),
        do: {:halt, index},
        else: {:cont, walk(robots, room)}
    end)
  end

  defp walk(robots, {rx, ry}) do
    robots
    |> Enum.map(fn robot = %{p: {px, py}, v: {vx, vy}} ->
      %{
        robot
        | p: {
            Integer.mod(px + vx, rx),
            Integer.mod(py + vy, ry)
          }
      }
    end)
  end
end
