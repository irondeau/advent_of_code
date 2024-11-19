defmodule AdventOfCode.Y2015.D18 do
  use AdventOfCode.Puzzle, year: 2015, day: 18

  @steps 100

  @impl true
  def title, do: "Like a GIF For Your Yard"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(fn char ->
        if char == "#", do: true, else: false
      end)
    end)
    |> Nx.tensor()
  end

  defp solve_1(light_matrix) do
    1..@steps
    |> Enum.reduce(light_matrix, fn _, light_matrix -> step(light_matrix) end)
    |> Nx.sum()
    |> Nx.to_number()
  end

  defp solve_2(light_matrix) do
    {size_x, size_y} = Nx.shape(light_matrix)

    corners =
      Nx.tensor([
        [0, 0],
        [size_x - 1, 0],
        [0, size_y - 1],
        [size_x - 1, size_y - 1]
      ])

    corner_updates = Nx.broadcast(1, {4})

    light_matrix = Nx.indexed_put(light_matrix, corners, corner_updates)

    1..@steps
    |> Enum.reduce(light_matrix, fn _, light_matrix ->
      step(light_matrix)
      |> Nx.indexed_put(corners, corner_updates)
    end)
    |> Nx.sum()
    |> Nx.to_number()
  end

  defp step(light_matrix) do
    illumination_matrix =
      Nx.window_reduce(light_matrix, 0, {3, 3}, [padding: :same, strides: [1, 1]], fn x, acc ->
        Nx.add(x, acc)
      end)

    on_matrix =
      Nx.logical_and(
        Nx.greater_equal(illumination_matrix, 3),
        Nx.less_equal(illumination_matrix, 4)
      )

    off_matrix =
      Nx.equal(illumination_matrix, 3)

    Nx.select(light_matrix, on_matrix, off_matrix)
  end
end
