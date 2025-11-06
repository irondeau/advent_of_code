defmodule AdventOfCode.Y2022.D5 do
  use AdventOfCode.Puzzle, year: 2022, day: 5

  @impl true
  def title, do: "Supply Stacks"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    [raw_crates, raw_instructions] =
      input
      |> String.split(~r/\R\R/)
      |> Enum.map(&String.split(&1, ~r/\R/))

    crates =
      raw_crates
      |> List.delete_at(-1)
      |> Enum.map(fn line ->
        line
        |> String.graphemes()
        |> Enum.chunk_every(3, 4)
        |> get_in([Access.all(), Access.at!(1)])
      end)
      |> transpose()
      |> Enum.map(&sanitize/1)

    instructions =
      raw_instructions
      |> Enum.map(&read/1)
      |> Enum.reject(&Enum.empty?/1)

    {crates, instructions}
  end

  defp solve_1({crates, instructions}) do
    process_1(crates, instructions)
    |> Enum.map(&hd/1)
    |> Enum.join()
  end

  defp solve_2({crates, instructions}) do
    process_2(crates, instructions)
    |> Enum.map(&hd/1)
    |> Enum.join()
  end

  defp transpose(crate_matrix) do
    Enum.zip_with(crate_matrix, &Function.identity/1)
  end

  defp sanitize([" " | rest]), do: sanitize(rest)
  defp sanitize(list), do: list

  defp read(instruction) do
    Regex.scan(~r/(\w+) (\d+)/, instruction)
    |> Enum.map(fn [_, key, value] ->
      {String.to_atom(key), String.to_integer(value)}
    end)
  end

  defp process_1(crates, [instruction | rest]) do
    move = Keyword.fetch!(instruction, :move)
    from = Keyword.fetch!(instruction, :from)
    to = Keyword.fetch!(instruction, :to)

    crates =
      for _ <- 1..move, reduce: crates do
        acc -> move_1(acc, from - 1, to - 1)
      end

    process_1(crates, rest)
  end

  defp process_1(crates, []), do: crates

  defp move_1(crates, from, to) do
    {crate, crates} =
      get_and_update_in(crates, [Access.at(from)], fn [crate | rest] ->
        {crate, rest}
      end)

    update_in(crates, [Access.at(to)], &[crate | &1])
  end

  defp process_2(crates, [instruction | rest]) do
    move = Keyword.fetch!(instruction, :move)
    from = Keyword.fetch!(instruction, :from)
    to = Keyword.fetch!(instruction, :to)

    crates
    |> move_2(move, from - 1, to - 1)
    |> process_2(rest)
  end

  defp process_2(crates, []), do: crates

  defp move_2(crates, move, from, to) do
    {moving, crates} =
      get_and_update_in(crates, [Access.at(from)], fn crates ->
        Enum.split(crates, move)
      end)

    update_in(crates, [Access.at(to)], &(moving ++ &1))
  end
end
