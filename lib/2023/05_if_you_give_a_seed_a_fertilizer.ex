defmodule AdventOfCode.Y2023.D5 do
  use AdventOfCode.Puzzle, year: 2023, day: 5

  @impl true
  def title, do: "If You Give A Seed A Fertilizer"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse("seeds: " <> input) do
    [seeds, maps] = String.split(input, ~r/\R/, parts: 2, trim: true)

    seeds =
      seeds
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    maps =
      maps
      |> String.split(~r/\R\R/, trim: true)
      |> Enum.map(fn category ->
        Regex.named_captures(~r/(?<from>.*)-to-(?<to>.*) map:\R(?<map>[\R\d\s]*)/, category)
        |> Map.update("map", nil, fn map ->
          map
          |> String.split(~r/\R/)
          |> Enum.map(fn range ->
            [to_range_start, from_range_start, range_len] =
              range
              |> String.split()
              |> Enum.map(&String.to_integer/1)

            %{
              to_range: Range.new(to_range_start, to_range_start + range_len - 1),
              from_range: Range.new(from_range_start, from_range_start + range_len - 1)
            }
          end)
        end)
      end)

    {seeds, maps}
  end

  defp solve_1({seeds, maps}) do
    seeds
    |> Enum.map(fn seed ->
      seed_map = get_map(maps, "seed")
      map_next(seed_map, seed)
      |> then(&(map_next(get_map(maps, elem(&1, 0)), elem(&1, 1))))
      |> then(&(map_next(get_map(maps, elem(&1, 0)), elem(&1, 1))))
      |> then(&(map_next(get_map(maps, elem(&1, 0)), elem(&1, 1))))
      |> then(&(map_next(get_map(maps, elem(&1, 0)), elem(&1, 1))))
      |> then(&(map_next(get_map(maps, elem(&1, 0)), elem(&1, 1))))
      |> then(&(map_next(get_map(maps, elem(&1, 0)), elem(&1, 1))))
      |> elem(1)
    end)
    |> Enum.min()
  end

  defp solve_2({seeds, maps}) do
    seeds
    |> Enum.chunk_every(2)
    |> Enum.map(fn [from_range, range_len] ->
      Range.new(from_range, from_range + range_len - 1)
    end)
    |> Enum.map(fn seed_range ->
      map_range(maps, get_map(maps, "seed"), seed_range)
    end)
    |> Enum.min()
  end

  defp get_map(maps, name), do: Enum.find(maps, fn %{"from" => from} -> from == name end)

  defp map_next(map, value) do
    to_value =
      map["map"]
      |> Enum.find(fn %{from_range: from_range} ->
        value in from_range
      end)
      |> case do
        nil -> value
        %{to_range: to_range, from_range: from_range} ->
          value - from_range.first + to_range.first
      end

    {map["to"], to_value}
  end

  defp map_range(_maps, %{"to" => "location"} = map, range) do
    map["map"]
    |> Enum.map_reduce([range], fn %{from_range: from_range} = range_mapping, unmapped_ranges ->
      {intersected_ranges, unmapped_ranges} = split_ranges(unmapped_ranges, from_range)

      min_value =
        intersected_ranges
        |> Enum.map(fn intersected_range ->
          range_transform(range_mapping, intersected_range).first
        end)

      {min_value, unmapped_ranges}
    end)
    |> then(fn {min_values, unmapped_ranges} ->
      # unmapped ranges map directly to the next category
      unmapped_min_value =
        unmapped_ranges
        |> Enum.map(fn unmapped_range -> unmapped_range.first end)
        |> Enum.reject(&(&1 == nil))
        |> Enum.min(fn -> nil end)

      min_value =
        min_values
        |> List.flatten()
        |> Enum.reject(&(&1 == nil))
        |> Enum.min(fn -> nil end)

      min(min_value, unmapped_min_value)
    end)
  end

  defp map_range(maps, map, range) do
    map["map"]
    |> Enum.map_reduce([range], fn %{from_range: from_range} = range_mapping, unmapped_ranges ->
      {intersected_ranges, unmapped_ranges} = split_ranges(unmapped_ranges, from_range)

      min_value =
        intersected_ranges
        |> Enum.map(fn intersected_range ->
          map_range(maps, get_map(maps, map["to"]), range_transform(range_mapping, intersected_range))
        end)
        |> Enum.min(fn -> nil end)

      {min_value, unmapped_ranges}
    end)
    |> then(fn {min_values, unmapped_ranges} ->
      # unmapped ranges map directly to the next category
      unmapped_min_value =
        unmapped_ranges
        |> Enum.map(fn unmapped_range -> map_range(maps, get_map(maps, map["to"]), unmapped_range) end)
        |> Enum.reject(&(&1 == nil))
        |> Enum.min(fn -> nil end)

      min_value =
        min_values
        |> List.flatten()
        |> Enum.reject(&(&1 == nil))
        |> Enum.min(fn -> nil end)

      min(min_value, unmapped_min_value)
    end)
  end

  defp split_ranges(ranges, over_range) do
    ranges
    |> Enum.map(fn range ->
      {
        range_intersect(range, over_range),
        range_difference(range, over_range)
      }
    end)
    |> Enum.unzip()
    |> then(fn {intersected_ranges, difference_ranges} ->
      {
        Enum.reject(intersected_ranges, &(&1 == nil)),
        List.flatten(difference_ranges)
      }
    end)
  end

  defp range_transform(%{to_range: to_range, from_range: from_range}, range) do
    Range.new(range.first - from_range.first + to_range.first, range.last - from_range.last + to_range.last)
  end

  defp range_intersect(range1, range2) do
    if not Range.disjoint?(range1, range2), do: Range.new(max(range1.first, range2.first), min(range1.last, range2.last))
  end

  defp range_difference(range1, range2) do
    []
    |> prepend_if(range1.first < range2.first, Range.new(range1.first, min(range1.last, range2.first - 1)))
    |> prepend_if(range1.last > range2.last, Range.new(max(range1.first, range2.last + 1), range1.last))
  end

  defp prepend_if(list, false, _element), do: list
  defp prepend_if(list, true, element), do: [element | list]
end
