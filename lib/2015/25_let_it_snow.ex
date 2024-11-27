defmodule AdventOfCode.Y2015.D25 do
  use AdventOfCode.Puzzle, year: 2015, day: 25

  @first 20151125
  @base 252533
  @divisor 33554393

  @impl true
  def title, do: "Let It Snow"

  @impl true
  def solve({row, column}) do
    exp = triangulate(row, column)
    Integer.mod(mod_pow(@base, exp, @divisor) * @first, @divisor)
  end

  @impl true
  def parse(input) do
    message = Regex.named_captures(~r/row (?<row>\d+), column (?<column>\d+)/, input)

    {String.to_integer(message["row"]), String.to_integer(message["column"])}
  end

  defp triangulate(row, column),
    do: div((row + column - 2) * (row + column - 1), 2) + column - 1

  defp mod_pow(x, y, m),
    do: :crypto.mod_pow(x, y, m) |> :crypto.bytes_to_integer()
end
