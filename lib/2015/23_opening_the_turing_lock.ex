defmodule AdventOfCode.Y2015.D23 do
  use AdventOfCode.Puzzle, year: 2015, day: 23

  require Integer
  require IEx

  @impl true
  def title, do: "Opening the Turing Lock"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    :ets.new(:registers, [:named_table])
    :ets.insert(:registers, {"a", 0})
    :ets.insert(:registers, {"b", 0})

    input
    |> String.split(~r/\R/)
    |> Enum.map(&String.split(&1, [" ", ","], trim: true))
  end

  defp solve_1(instrs, index \\ 0) do
    instr = Enum.at(instrs, index)

    case exec(instr, index) do
      :halt ->
        result = :ets.lookup(:registers, "b") |> hd() |> elem(1)
        :ets.insert(:registers, {"a", 0})
        :ets.insert(:registers, {"b", 0})
        result

      index ->
        solve_1(instrs, index)
    end
  end

  defp solve_2(instrs) do
    :ets.update_element(:registers, "a", {2, 1})
    solve_1(instrs)
  end

  defp exec(["hlf", r], index) do
    [{^r, value}] = :ets.lookup(:registers, r)
    :ets.update_element(:registers, r, {2, div(value, 2)})
    index + 1
  end

  defp exec(["tpl", r], index) do
    [{^r, value}] = :ets.lookup(:registers, r)
    :ets.update_element(:registers, r, {2, value * 3})
    index + 1
  end

  defp exec(["inc", r], index) do
    [{^r, value}] = :ets.lookup(:registers, r)
    :ets.update_element(:registers, r, {2, value + 1})
    index + 1
  end

  defp exec(["jmp", offset], index) do
    index + String.to_integer(offset)
  end

  defp exec(["jie", r, offset], index) do
    [{^r, value}] = :ets.lookup(:registers, r)

    if Integer.is_even(value) do
      index + String.to_integer(offset)
    else
      index + 1
    end
  end

  defp exec(["jio", r, offset], index) do
    [{^r, value}] = :ets.lookup(:registers, r)

    if value == 1 do
      index + String.to_integer(offset)
    else
      index + 1
    end
  end

  defp exec(_instr, _index), do: :halt
end
