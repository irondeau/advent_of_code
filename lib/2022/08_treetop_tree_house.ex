defmodule AdventOfCode.Y2022.D8 do
  use AdventOfCode.Puzzle, year: 2022, day: 8

  @impl true
  def title, do: "Treetop Tree House"

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
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Nx.tensor(names: [:y, :x])
  end

  defp solve_1(forest) do
    [
      visible(forest, axis: :x, reverse: false),
      visible(forest, axis: :x, reverse: true),
      visible(forest, axis: :y, reverse: false),
      visible(forest, axis: :y, reverse: true)
    ]
    |> Enum.reduce(&Nx.bitwise_or/2)
    |> Nx.sum()
    |> Nx.to_number()
  end

  defp solve_2(_input) do
    nil
  end

  # Returns a matrix of 0s or 1s for visible trees observed along the given axis
  defp visible(forest, opts) do
    reverse = Keyword.fetch!(opts, :reverse)

    if reverse do
      forest
      |> Nx.reverse()
      |> do_visible(opts)
      |> Nx.reverse()
    else
      do_visible(forest, opts)
    end
  end

  defp do_visible(forest, opts) do
    axis = Keyword.fetch!(opts, :axis)

    axis_size = Nx.axis_size(forest, axis)
    running_max = Nx.cumulative_max(forest, axis: axis)

    visible_matrix =
      Nx.less(
        Nx.slice_along_axis(running_max, 0, axis_size - 1, axis: axis),
        Nx.slice_along_axis(forest, 1, axis_size - 1, axis: axis)
      )

    Nx.concatenate(
      [
        padding_along_axis(forest, axis),
        visible_matrix
      ],
      axis: axis
    )
  end

  defp padding_along_axis(tensor, axis) do
    index = Nx.axis_index(tensor, axis)

    padding_shape =
      tensor
      |> Nx.shape()
      |> Tuple.to_list()
      |> List.replace_at(index, 1)
      |> List.to_tuple()

    Nx.broadcast(1, padding_shape, names: Nx.names(tensor))
  end
end
