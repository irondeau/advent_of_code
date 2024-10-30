defmodule AdventOfCode.Y2015.D7 do
  use AdventOfCode.Puzzle, year: 2015, day: 7

  @impl true
  def title, do: "Some Assembly Required"

  @impl true
  def solve(input) do
    input
    |> then(fn wire_map ->
      sol_1 = solve_1(wire_map)
      {sol_1, solve_2(wire_map, sol_1)}
    end)
  end

  @impl true
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(%{}, &tokenize/2)
  end

  defp solve_1(wire_map) do
    :ets.new(:wire_registry, [:named_table])
    sig = get_signal(wire_map, "a")
    :ets.delete(:wire_registry)
    <<sig :: unsigned-integer-16>> = <<sig :: integer-signed-16>>
    sig
  end

  defp solve_2(wire_map, sol_1) do
    :ets.new(:wire_registry, [:named_table])
    wire_map = Map.put(wire_map, "b", [:bind, sol_1])
    sig = get_signal(wire_map, "a")
    :ets.delete(:wire_registry)
    <<sig :: unsigned-integer-16>> = <<sig :: integer-signed-16>>
    sig
  end

  defp tokenize(instr, wire_map) do
    case String.split(instr) do
      ["NOT", arg, "->", out] ->
        Map.put(wire_map, out, [:not, sanitize(arg)])
      [arg_1, op, arg_2, "->", out] when op in ~w/AND OR LSHIFT RSHIFT/ ->
        Map.put(wire_map, out, [String.to_atom(String.downcase(op)), sanitize(arg_1), sanitize(arg_2)])
      [arg, "->", out] ->
        Map.put(wire_map, out, [:bind, sanitize(arg)])
    end
  end

  defp sanitize(value) do
    case Integer.parse(value) do
      {value, _} -> value
      :error -> value
    end
  end

  @instr_mapping %{
    bind: &Function.identity/1,
    not: &Bitwise.bnot/1,
    and: &Bitwise.band/2,
    or: &Bitwise.bor/2,
    lshift: &Bitwise.bsl/2,
    rshift: &Bitwise.bsr/2,
  }

  defp get_signal(wire_map, wire) do
    instr = Map.get(wire_map, wire)
    case :ets.lookup(:wire_registry, instr) do
      [{_instr, value}] -> value
      [] ->
        value = case instr do
          # arity 1
          [instr, arg] when is_atom(instr) and is_integer(arg) ->
            apply(@instr_mapping[instr], [arg])
          [instr, arg] when is_atom(instr) and is_binary(arg) ->
            apply(@instr_mapping[instr], [get_signal(wire_map, arg)])

          # arity 2
          [instr, arg_1, arg_2] when is_atom(instr) and is_binary(arg_1) and is_binary(arg_2) ->
            apply(@instr_mapping[instr], [get_signal(wire_map, arg_1), get_signal(wire_map, arg_2)])
          [instr, arg_1, arg_2] when is_atom(instr) and is_binary(arg_1) and is_integer(arg_2) ->
            apply(@instr_mapping[instr], [get_signal(wire_map, arg_1), arg_2])
          [instr, arg_1, arg_2] when is_atom(instr) and is_integer(arg_1) and is_binary(arg_2) ->
            apply(@instr_mapping[instr], [arg_1, get_signal(wire_map, arg_2)])
          [instr, arg_1, arg_2] when is_atom(instr) and is_integer(arg_1) and is_integer(arg_2) ->
            apply(@instr_mapping[instr], [arg_1, arg_2])
        end
        :ets.insert(:wire_registry, {instr, value})
        value
    end
  end
end
