defmodule AdventOfCode.Y2015.D2 do
  use AdventOfCode.Puzzle, year: 2015, day: 2

  @impl true
  def title, do: "I Was Told There Would Be No Math"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split()
    |> Enum.map(fn line ->
      Regex.named_captures(~r/(?<l>\d+)x(?<w>\d+)x(?<h>\d+)/, line)
      |> Enum.into(%{}, fn {k, v} -> {k, String.to_integer(v)} end)
    end)
  end

  defp solve_1(dims) do
    dims
    |> Enum.reduce(0, fn %{"l" => l, "w" => w, "h" => h}, acc ->
      face_dims = [l*w, w*h, h*l]
      acc + 2 * Enum.sum(face_dims) + Enum.min(face_dims)
    end)
  end

  defp solve_2(dims) do
    dims
    |> Enum.reduce(0, fn %{"l" => l, "w" => w, "h" => h}, acc ->
      face_perims = [2*(l+w), 2*(w+h), 2*(h+l)]
      acc + Enum.min(face_perims) + l*w*h
    end)
  end
end
