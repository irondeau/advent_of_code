defmodule AdventOfCode.Y2025.D6 do
  use AdventOfCode.Puzzle, year: 2025, day: 6

  @impl true
  def title, do: "Trash Compactor"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    {rows, raw_ops} =
      input
      |> String.split(~r/\R/)
      |> Enum.drop(-1)
      |> Enum.map(fn line ->
        String.graphemes(line)
      end)
      |> Enum.split(-1)

    grouped_cols =
      rows
      |> transpose()
      |> group_cols()

    ops =
      raw_ops
      |> List.flatten()
      |> Enum.reverse()
      |> Enum.reject(&(&1 == " "))

    Enum.zip(grouped_cols, ops)
  end

  defp solve_1(worksheet) do
    worksheet
    |> update_in([Access.all(), Access.elem(0)], fn num_matrix ->
      num_matrix
      |> transpose()
      |> Enum.map(&Enum.reverse/1)
    end)
    |> solve_2()
  end

  defp solve_2(worksheet) do
    worksheet
    |> update_in([Access.all(), Access.elem(0)], fn num_matrix ->
      Enum.map(num_matrix, fn row ->
        row
        |> Enum.reject(&(&1 == " "))
        |> Enum.map(&String.to_integer/1)
        |> Integer.undigits()
      end)
    end)
    |> Enum.map(fn
      {nums, "+"} -> Enum.sum(nums)
      {nums, "*"} -> Enum.product(nums)
    end)
    |> Enum.sum()
  end

  defp transpose(matrix) do
    Enum.zip_with(matrix, &Function.identity/1)
  end

  defp group_cols(cols, group \\ [], acc \\ [])

  defp group_cols([], group, acc), do: [group | acc]

  defp group_cols([hd | rest], group, acc) do
    if Enum.all?(hd, &(&1 == " ")) do
      group_cols(rest, [], [group | acc])
    else
      group_cols(rest, [hd | group], acc)
    end
  end
end
