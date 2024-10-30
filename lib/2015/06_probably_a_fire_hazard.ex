defmodule AdventOfCode.Y2015.D6 do
  use AdventOfCode.Puzzle, year: 2015, day: 6

  @default_shape {1000, 1000}

  @impl true
  def title, do: "Probably A Fire Hazard"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      Regex.named_captures(~r/(?<instr>\w[\w\s]+) (?<x1>\d+),(?<y1>\d+) through (?<x2>\d+),(?<y2>\d+)/, line)
      |> Enum.into(%{}, fn {k, v} ->
        if k in ["x1", "y1", "x2", "y2"] do
          {k, String.to_integer(v)}
        else
          {k, v}
        end
      end)
    end)
  end

  defp solve_1(instrs) do
    Enum.reduce(instrs, Nx.broadcast(0, @default_shape),
      fn %{"instr" => instr, "x1" => x1, "y1" => y1, "x2" => x2, "y2" => y2}, matrix ->
        case instr do
          "turn off" ->
            Nx.put_slice(matrix, [x1, y1], Nx.broadcast(0, {x2 - x1 + 1, y2 - y1 + 1}))
          "turn on" ->
            Nx.put_slice(matrix, [x1, y1], Nx.broadcast(1, {x2 - x1 + 1, y2 - y1 + 1}))
          "toggle" ->
            slice = Nx.logical_not(Nx.slice(matrix, [x1, y1], [x2 - x1 + 1, y2 - y1 + 1]))
            Nx.put_slice(matrix, [x1, y1], slice)
        end
      end
    )
    |> Nx.sum()
    |> Nx.to_number()
  end

  defp solve_2(instrs) do
    Enum.reduce(instrs, Nx.broadcast(0, @default_shape),
      fn %{"instr" => instr, "x1" => x1, "y1" => y1, "x2" => x2, "y2" => y2}, matrix ->
        submatrix = Nx.slice(matrix, [x1, y1], [x2 - x1 + 1, y2 - y1 + 1])
        case instr do
          "turn off" ->
            Nx.put_slice(matrix, [x1, y1], Nx.clip(Nx.subtract(submatrix, 1), 0, Nx.Constants.max({:s, 64})))
          "turn on" ->
            Nx.put_slice(matrix, [x1, y1], Nx.add(submatrix, 1))
          "toggle" ->
            Nx.put_slice(matrix, [x1, y1], Nx.add(submatrix, 2))
        end
      end
    )
    |> Nx.sum()
    |> Nx.to_number()
  end
end
