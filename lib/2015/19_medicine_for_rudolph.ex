defmodule AdventOfCode.Y2015.D19 do
  use AdventOfCode.Puzzle, year: 2015, day: 19

  @impl true
  def title, do: "Medicine for Rudolph"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    [replacements, molecule] = String.split(input, ~r/\R\R/)

    replacements =
      replacements
      |> String.split(~r/\R/)
      |> Enum.reduce(%{}, fn line, replacements ->
        [from, to] = String.split(line, " => ")

        if Map.has_key?(replacements, from) do
          update_in(replacements, [from], & [to | &1])
        else
          Map.put(replacements, from, [to])
        end
      end)
      |> Enum.into(%{})

    {replacements, molecule}
  end

  defp solve_1({replacements, molecule}) do
    replacements
    |> Enum.flat_map(fn {r_key, r_values} ->
      regex = Regex.compile!(r_key)

      r_values
      |> Enum.flat_map(fn r_value ->
        Regex.scan(regex, molecule, return: :index)
        |> Enum.map(fn [{index, length}] ->
          replace(molecule, index, length, r_value)
        end)
      end)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp solve_2({_replacements, molecule}) do
    # https://www.reddit.com/r/adventofcode/comments/3xflz8/comment/cy4etju/
    ignoble_atom_count =
      Regex.scan(~r/(?!Ar|Rn)[A-Z][a-z]?/, molecule)
      |> Enum.count()

    yttrium_count =
      Regex.scan(~r/Y/, molecule)
      |> Enum.count()

    ignoble_atom_count - yttrium_count * 2 - 1
  end

  defp replace(string, index, length, substring) do
    {prefix, rest} = String.split_at(string, index)
    {_, suffix} = String.split_at(rest, length)

    prefix <> substring <> suffix
  end
end
