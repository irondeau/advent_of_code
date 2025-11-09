defmodule AdventOfCode.Y2022.D7 do
  use AdventOfCode.Puzzle, year: 2022, day: 7

  @impl true
  def title, do: "No Space Left On Device"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> catalog()
  end

  defp solve_1(catalog) do
    catalog
    |> calculate_dir_sizes()
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  defp solve_2(catalog) do
    [root_size | dir_sizes] =
      calculate_dir_sizes(catalog)

    unused_space = 70_000_000 - root_size
    reqd_space = 30_000_000 - unused_space

    Enum.min_by(dir_sizes, fn
      dir_size when dir_size < reqd_space -> nil
      dir_size -> dir_size
    end)
  end

  defp catalog(lines, path \\ [], acc \\ %{})

  defp catalog(["$ cd .." | lines], path, acc) do
    catalog(lines, tl(path), acc)
  end

  defp catalog(["$ cd " <> dir | lines], path, acc) do
    catalog(lines, [dir | path], acc)
  end

  defp catalog([line | lines], path, acc) do
    acc =
      case Integer.parse(line) do
        {size, " " <> file} ->
          [file | path]
          |> Enum.reverse()
          |> Enum.map(&Access.key(&1, %{}))
          |> then(&put_in(acc, &1, size))

        :error ->
          acc
      end

    catalog(lines, path, acc)
  end

  defp catalog([], _path, acc), do: acc

  defp calculate_dir_sizes(%{"/" => contents}) do
    {"/", contents}
    |> do_calculate_dir_sizes()
    |> elem(1)
  end

  defp do_calculate_dir_sizes({_file, size}) when is_integer(size) do
    {size, []}
  end

  defp do_calculate_dir_sizes({_dir, contents}) do
    {dir_size, acc} =
      contents
      |> Enum.map(&do_calculate_dir_sizes/1)
      |> Enum.reduce(fn {a, b}, {c, d} ->
        {a + c, b ++ d}
      end)

    {dir_size, [dir_size | acc]}
  end
end
