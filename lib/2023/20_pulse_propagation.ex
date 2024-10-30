defmodule AdventOfCode.Y2023.D20 do
  use AdventOfCode.Puzzle, year: 2023, day: 20

  import AdventOfCode.Helpers.Math

  @impl true
  def title, do: "Pulse Propagation"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    modules =
      input
      |> String.split(~r/\R/)
      |> Enum.map(&parse_module/1)
      |> Map.new()

    # prepare conjunction states
    conj_map =
      modules
      |> Map.filter(fn {_key, value} ->
        case value do
          %{type: :conjunction} -> true
          _ -> false
        end
      end)
      |> Enum.map(fn {key, value} ->
        src_state =
          modules
          |> Map.filter(fn {_key, %{dst: dst}} -> key in dst end)
          |> Map.keys()
          |> Enum.map(&{&1, false})
          |> Map.new()

        {key, %{value | state: src_state}}
      end)
      |> Map.new()

    Map.merge(modules, conj_map)
  end

  defp solve_1(modules) do
    batch = :queue.in({"broadcaster", {"button", false}}, :queue.new())

    1..1000
    |> Enum.reduce({modules, %{low: 0, high: 0}}, fn _, {modules, acc} ->
      {modules, %{low: cycle_low, high: cycle_high}} = cycle(modules, batch)

      acc =
        acc
        |> Map.update!(:low, &(&1 + cycle_low))
        |> Map.update!(:high, &(&1 + cycle_high))

      {modules, acc}
    end)
    |> elem(1)
    |> Map.values()
    |> Enum.product()
  end

  defp solve_2(modules) do
    modules
    |> Map.filter(fn {key, _value} -> key in modules["broadcaster"][:dst] end)
    |> Enum.map(fn module ->
      build_chain(modules, module)
      |> pad_leading_zeros()
      |> :binary.decode_unsigned()
    end)
    |> lcm()
  end

  defp parse_module("broadcaster -> " <> dst), do: {"broadcaster", %{dst: String.split(dst, ", ")}}
  defp parse_module("%" <> module), do: parse_module(module, type: :flipflop, state: false)
  defp parse_module("&" <> module), do: parse_module(module, type: :conjunction, state: %{})

  defp parse_module(module, opts) do
    [key, dst] = String.split(module, " -> ")

    {key, %{type: opts[:type], state: opts[:state], dst: String.split(dst, ", ")}}
  end

  defp cycle(modules, batch, count \\ %{low: 1, high: 0}) do
    if :queue.is_empty(batch) do
      {modules, count}
    else
      {modules, next_batch, count} =
        batch
        |> :queue.to_list()
        |> Enum.reduce({modules, :queue.new(), count}, fn {key, {from, pulse}}, {modules, next_batch, count} ->
          case modules[key] do
            nil ->
              {modules, next_batch, count}

            %{type: :flipflop, state: state, dst: dst} = module ->
              if pulse do
                {modules, next_batch, count}
              else
                {%{modules | key => %{module | state: not state}},
                 :queue.join(next_batch, :queue.from_list(Enum.map(dst, &{&1, {key, not state}}))),
                 Map.update!(count, if(not state, do: :high, else: :low), &(&1 + length(dst)))}
              end

            %{type: :conjunction, state: state, dst: dst} = module ->
              state = %{state | from => pulse}

              if state |> Map.values() |> Enum.all?() do
                {%{modules | key => %{module | state: state}},
                :queue.join(next_batch, :queue.from_list(Enum.map(dst, &{&1, {key, false}}))),
                 Map.update!(count, :low, &(&1 + length(dst)))}
              else
                {%{modules | key => %{module | state: state}},
                :queue.join(next_batch, :queue.from_list(Enum.map(dst, &{&1, {key, true}}))),
                 Map.update!(count, :high, &(&1 + length(dst)))}
              end

            %{dst: dst} ->
              {modules,
               :queue.join(next_batch, :queue.from_list(Enum.map(dst, &{&1, {key, pulse}}))),
               Map.update!(count, if(pulse, do: :high, else: :low), &(&1 + length(dst)))}
          end
        end)

      cycle(modules, next_batch, count)
    end
  end

  defp build_chain(modules, {key, %{dst: dst}}, acc \\ <<>>) do
    modules = Map.drop(modules, [key])

    dst_modules = Map.take(modules, dst)
    next_flipflop = Enum.filter(dst_modules, fn {_key, %{type: type}} -> type == :flipflop end)
    has_conjunction? = map_size(dst_modules) > 1

    if length(next_flipflop) == 0 do
      <<1::1, acc::bitstring>>
    else
      build_chain(
        modules,
        hd(next_flipflop),
        if(has_conjunction?, do: <<1::1, acc::bitstring>>, else: <<0::1, acc::bitstring>>)
      )
    end
  end

  def pad_leading_zeros(bs) when is_binary(bs), do: bs
  def pad_leading_zeros(bs) when is_bitstring(bs) do
    pad_length = 8 - rem(bit_size(bs), 8)
    <<0::size(pad_length), bs::bitstring>>
  end
end
