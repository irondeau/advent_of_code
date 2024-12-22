defmodule AdventOfCode.Y2024.D22 do
  use AdventOfCode.Puzzle, year: 2024, day: 22

  require Integer

  @impl true
  def title, do: "Monkey Market"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&String.to_integer/1)
  end

  defp solve_1(secret_numbers) do
    secret_numbers
    |> Enum.map(fn secret ->
      for _ <- 1..2000, reduce: secret do
        secret -> generate(secret)
      end
    end)
    |> Enum.sum()
  end

  defp solve_2(secret_numbers) do
    secret_numbers
    |> Enum.map(fn secret ->
      prices =
        for _ <- 1..2000, reduce: {secret, [price(secret)]} do
          {secret, prices} ->
            secret = generate(secret)
            {secret, [price(secret) | prices]}
        end
        |> elem(1)
        |> Enum.reverse()

      prices
      |> deltas()
      |> Enum.chunk_every(4, 1, :discard)
      |> Enum.map(fn chunk ->
        {[_, _, _, price], seq} = Enum.unzip(chunk)
        {seq, price}
      end)
      |> Enum.reduce(%{}, fn {seq, price}, map ->
        Map.put_new(map, seq, price)
      end)
    end)
    |> Enum.reduce(fn map, acc_map ->
      Map.merge(acc_map, map, fn _k, v1, v2 ->
        v1 + v2
      end)
    end)
    |> Enum.max_by(&elem(&1, 1))
    |> elem(1)
  end

  defp generate(secret) do
    secret =
      secret
      |> mix(secret * 64)
      |> prune()

    secret =
      secret
      |> mix(div(secret, 32))
      |> prune()

    secret
    |> mix(secret * 2048)
    |> prune()
  end

  defdelegate mix(secret, value), to: Bitwise, as: :bxor

  defp prune(secret), do: Integer.mod(secret, 16777216)

  defp deltas(prices) do
    prices
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> {b, b - a} end)
  end

  defp price(secret), do: Integer.mod(secret, 10)
end
