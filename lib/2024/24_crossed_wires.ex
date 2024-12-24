defmodule AdventOfCode.Y2024.D24 do
  use AdventOfCode.Puzzle, year: 2024, day: 24

  @impl true
  def title, do: "Crossed Wires"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    [state, gates] = String.split(input, ~r/\R\R/)

    state =
      state
      |> String.split(~r/\R/)
      |> Map.new(fn line ->
        [key, value] = String.split(line, ": ")
        {key, String.to_integer(value)}
      end)

    gates =
      gates
      |> String.split(~r/\R/)
      |> Enum.map(fn line ->
        case String.split(line) do
          [a, "OR", b, "->", c] -> {:bor, a, b, c}
          [a, "AND", b, "->", c] -> {:band, a, b, c}
          [a, "XOR", b, "->", c] -> {:bxor, a, b, c}
        end
      end)

    {gates, state}
  end

  defp solve_1({gates, state}) do
    propagate(gates, state)
    |> to_map()
    |> Map.get("z")
  end

  defp solve_2({gates, _state}) do
    gates
    |> Enum.reject(fn
      # special case for leading half adder
      {_op, "x00", "y00", _c} ->
        true

      # OR gates only ever output to "z45"
      {:bor, _a, _b, "z" <> offset} ->
        offset == "45"

      # AND gates never output to z## wires
      {:band, _a, _b, "z" <> _rest} ->
        false

      # AND gates always connect to OR gates
      {:band, _a, _b, c} ->
        Enum.reduce_while(gates, true, fn
          {sub_op, ^c, _, _}, _ when sub_op != :bor -> {:halt, false}
          {sub_op, _, ^c, _}, _ when sub_op != :bor -> {:halt, false}
          _, _ -> {:cont, true}
        end)

      # XOR gates must either have x## and y## as inputs or z## as an output
      {:bxor, <<a_id>> <> _, <<b_id>> <> _, <<c_id>> <> _}
      when <<a_id>> not in ~w/x y z/ and
             <<b_id>> not in ~w/x y z/ and
             <<c_id>> not in ~w/x y z/ ->
        false

      # otherwise, XOR gates never connect to OR gates
      {:bxor, _a, _b, c} ->
        Enum.reduce_while(gates, true, fn
          {sub_op, ^c, _, _}, _ when sub_op == :bor -> {:halt, false}
          {sub_op, _, ^c, _}, _ when sub_op == :bor -> {:halt, false}
          _, _ -> {:cont, true}
        end)

      _ ->
        true
    end)
    |> Enum.map(&elem(&1, 3))
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp propagate([], state), do: state

  defp propagate(gates, state) do
    {gates, state} =
      for {op, a, b, c} <- gates, reduce: {gates, state} do
        {gates, state} ->
          with {:ok, a_val} <- Map.fetch(state, a),
               {:ok, b_val} <- Map.fetch(state, b) do
            c_val = apply(Bitwise, op, [a_val, b_val])
            state = Map.put(state, c, c_val)
            gates = List.delete(gates, {op, a, b, c})
            {gates, state}
          else
            :error -> {gates, state}
          end
      end

    propagate(gates, state)
  end

  defp to_map(state) do
    state
    |> Map.filter(fn {<<id>> <> _, _v} -> id in ?x..?z end)
    |> Enum.sort(:desc)
    |> Enum.group_by(fn {k, _v} -> String.first(k) end, &elem(&1, 1))
    |> Map.new(fn {k, v} -> {k, Integer.undigits(v, 2)} end)
  end
end
