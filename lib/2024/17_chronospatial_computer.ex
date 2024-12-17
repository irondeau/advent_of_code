defmodule AdventOfCode.Y2024.D17 do
  use AdventOfCode.Puzzle, year: 2024, day: 17

  import Bitwise

  @impl true
  def title, do: "Chronospatial Computer"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    [reg, "Program: " <> prog] = String.split(input, ~r/\R\R/)

    reg =
      reg
      |> String.split(~r/\R/)
      |> Map.new(fn "Register " <> register ->
        [key, value] = String.split(register, ": ")
        {key, String.to_integer(value)}
      end)

    prog =
      prog
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)

    {prog, reg}
  end

  def solve_1({prog, reg}) do
    run(prog, reg)
    |> Enum.join(",")
  end

  defp solve_2({prog, _reg}) do
    run_reverse(prog)
    |> get_in([Access.all(), Access.key!("A")])
    |> Enum.min()
  end

  defp run(prog, reg, instr_ptr \\ 0, out \\ []) do
    case Enum.at(prog, instr_ptr) do
      nil ->
        Enum.reverse(out)

      # adv
      [0, operand] ->
        result = reg["A"] >>> combo(operand, reg)
        run(prog, %{reg | "A" => result}, instr_ptr + 1, out)

      # bxl
      [1, operand] ->
        result = bxor(reg["B"], operand)
        run(prog, %{reg | "B" => result}, instr_ptr + 1, out)

      # bst
      [2, operand] ->
        result = Integer.mod(combo(operand, reg), 8)
        run(prog, %{reg | "B" => result}, instr_ptr + 1, out)

      # jnz
      [3, operand] ->
        result = if reg["A"] == 0, do: instr_ptr + 1, else: operand
        run(prog, reg, result, out)

      # bxc
      [4, _operand] ->
        result = bxor(reg["B"], reg["C"])
        run(prog, %{reg | "B" => result}, instr_ptr + 1, out)

      # out
      [5, operand] ->
        result = Integer.mod(combo(operand, reg), 8)
        run(prog, reg, instr_ptr + 1, [result | out])

      # bdv
      [6, operand] ->
        result = reg["A"] >>> combo(operand, reg)
        run(prog, %{reg | "B" => result}, instr_ptr + 1, out)

      # cdv
      [7, operand] ->
        result = reg["A"] >>> combo(operand, reg)
        run(prog, %{reg | "C" => result}, instr_ptr + 1, out)
    end
  end

  defp combo(literal, _reg) when literal in 0..3, do: literal
  defp combo(4, %{"A" => value}), do: value
  defp combo(5, %{"B" => value}), do: value
  defp combo(6, %{"C" => value}), do: value

  defp run_reverse(prog), do: run_reverse(prog, List.flatten(prog))

  defp run_reverse(_prog, []), do: [%{"A" => 0, "B" => 0, "C" => 0}]

  defp run_reverse(prog, out) do
    for reg <- run_reverse(prog, tl(out)),
        lower_bits <- 0..7,
        reduce: [] do
      acc ->
        reg = Map.update!(reg, "A", &(&1 <<< 3 ||| lower_bits))

        if run(prog, reg) == out,
          do: [reg | acc],
          else: acc
    end
  end
end
