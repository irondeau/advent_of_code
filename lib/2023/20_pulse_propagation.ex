defmodule AdventOfCode.Y2023.D20 do
  use AdventOfCode.Puzzle, year: 2023, day: 20

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

  defp solve_2(_input) do
    nil
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
end
