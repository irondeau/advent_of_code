defmodule AdventOfCode.Y2025.D9 do
  use AdventOfCode.Puzzle, year: 2025, day: 9

  alias AdventOfCode.Helpers

  @impl true
  def title, do: "Movie Theater"

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
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp solve_1(tiles) do
    tiles
    |> Helpers.Enum.combinations(2)
    |> Enum.map(fn [[x1, y1], [x2, y2]] ->
      (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
    end)
    |> Enum.max()
  end

  defp solve_2(tiles) do
    edges =
      tiles
      |> Enum.chunk_every(2, 1, [hd(tiles)])

    tiles
    |> Helpers.Enum.combinations(2)
    |> Enum.reject(fn [[x1, y1], [x2, y2]] ->
      [
        [[x1, y1], [x2, y1]],
        [[x1, y1], [x1, y2]],
        [[x2, y2], [x1, y2]],
        [[x2, y2], [x2, y1]]
      ]
      |> Enum.any?(fn line1 ->
        Enum.any?(edges, fn line2 ->
          bisect?(line1, line2)
        end)
      end)
    end)
    |> IO.inspect(charlists: :as_lists)

    nil
  end

  defp bisect?([[x1, y1], [x2, y2]], [[x3, y3], [x4, y4]]) do
    denom =
      Nx.LinAlg.determinant(
        Nx.tensor([
          [x1 - x2, x3 - x4],
          [y1 - y2, y3 - y4]
        ])
      )

    t =
      Nx.LinAlg.determinant(
        Nx.tensor([
          [x1 - x3, x3 - x4],
          [y1 - y3, y3 - y4]
        ])
      )
      |> Nx.divide(denom)
      |> Nx.to_number()

    u =
      Nx.LinAlg.determinant(
        Nx.tensor([
          [x1 - x2, x1 - x3],
          [y1 - y2, y1 - y3]
        ])
      )
      |> Nx.negate()
      |> Nx.divide(denom)
      |> Nx.to_number()

    0 < t and t < 1 and 0 < u and u < 1
  end
end
