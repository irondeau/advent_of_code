defmodule AdventOfCode.Y2024.D7 do
  use AdventOfCode.Puzzle, year: 2024, day: 7

  @impl true
  def title, do: "Bridge Repair"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      [output, args] = String.split(line, ": ")

      {
        String.to_integer(output),
        args
        |> String.split()
        |> Enum.map(&String.to_integer/1)
        |> Enum.reverse()
      }
    end)
  end

  defp solve_1(equations) do
    equations
    |> Enum.filter(fn {output, args} ->
      solution?(output, args, [&Kernel.-/2, &divide/2])
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp solve_2(equations) do
    equations
    |> Enum.filter(fn {output, args} ->
      solution?(output, args, [&Kernel.-/2, &divide/2, &drop_suffix/2])
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp solution?(:error, _args, _ops), do: false
  defp solution?(output, _args, _ops) when output < 0, do: false
  defp solution?(output, [arg], _ops), do: arg == output

  defp solution?(output, [arg | rest], ops) do
    Enum.any?(ops, fn op ->
      solution?(op.(output, arg), rest, ops)
    end)
  end

  defp divide(a, b) do
    if Integer.mod(a, b) == 0 do
      div(a, b)
    else
      :error
    end
  end

  defp drop_suffix(a, b) do
    a = Integer.to_string(a)
    b = Integer.to_string(b)

    if String.ends_with?(a, b) do
      case String.replace_suffix(a, b, "") do
        "" -> :error
        c -> String.to_integer(c)
      end
    else
      :error
    end
  end
end
