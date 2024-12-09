defmodule AdventOfCode.Y2024.D9 do
  use AdventOfCode.Puzzle, year: 2024, day: 9

  @impl true
  def title, do: "Disk Fragmenter"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    tags =
      Stream.from_index()
      |> Stream.intersperse(:gap)

    input
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.zip(tags)
  end

  defp solve_1(data) do
    data
    |> Enum.flat_map(fn {count, id} ->
      List.duplicate({1, id}, count)
    end)
    |> defrag_1()
    |> checksum()
  end

  defp solve_2(data) do
    data
    |> defrag_2()
    |> checksum()
  end

  defp defrag_1(data), do: defrag_1(data, Enum.reverse(data), [])

  defp defrag_1(front, back, acc)

  defp defrag_1(front, [{1, :gap} | b_rest], acc), do: defrag_1(front, b_rest, acc)

  defp defrag_1([{1, :gap} | f_rest], [b_next | b_rest], acc),
    do: defrag_1(f_rest, b_rest, [b_next | acc])

  defp defrag_1([f_next | _f_rest], back = [b_next | _b_rest], acc) when f_next == b_next do
    Enum.reduce_while(back, acc, fn
      ^b_next, acc -> {:cont, [b_next | acc]}
      _, acc -> {:halt, acc}
    end)
    |> Enum.reverse()
  end

  defp defrag_1([f_next | f_rest], back, acc),
    do: defrag_1(f_rest, back, [f_next | acc])

  defp defrag_2(data) do
    data
    |> Enum.reverse()
    |> Enum.reduce(data, fn
      {_count, :gap}, data -> data
      block, data -> defrag_2(data, block, [])
    end)
  end

  defp defrag_2([], _block, acc), do: Enum.reverse(acc)
  defp defrag_2([block | _] = data, block, acc), do: Enum.reverse(acc, data)

  defp defrag_2([{count, :gap} | rest], {count, id}, acc),
    do: Enum.reverse(acc, [{count, id} | replace(rest, {count, id})])

  defp defrag_2([{gap_count, :gap} | rest], {count, id}, acc) when count < gap_count,
    do: Enum.reverse(acc, [{count, id}, {gap_count - count, :gap} | replace(rest, {count, id})])

  defp defrag_2([head | rest], block, acc), do: defrag_2(rest, block, [head | acc])

  defp replace([{a, :gap}, block, {b, :gap} | rest], {count, _} = block),
    do: [{a + count + b, :gap} | rest]

  defp replace([{a, :gap}, block | rest], {count, _} = block), do: [{a + count, :gap} | rest]
  defp replace([block, {b, :gap} | rest], {count, _} = block), do: [{count + b, :gap} | rest]
  defp replace([block | rest], {count, _} = block), do: [{count, :gap} | rest]
  defp replace([head | rest], block), do: [head | replace(rest, block)]

  defp checksum(data) do
    data
    |> Enum.reduce({0, 0}, fn
      {count, :gap}, {acc, index} -> {acc, index + count}
      {count, id}, {acc, index} ->
        score = Enum.sum(index..(index + count - 1)) * id
        {acc + score, index + count}
    end)
    |> elem(0)
  end
end
