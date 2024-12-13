defmodule AdventOfCode.Y2024.D13 do
  use AdventOfCode.Puzzle, year: 2024, day: 13

  @impl true
  def title, do: "Claw Contraption"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    input
    |> String.split(~r/\R\R/)
    |> Enum.map(fn claw_machine ->
      [
        "Button A: X" <> a,
        "Button B: X" <> b,
        "Prize: X=" <> prize
      ] = String.split(claw_machine, ~r/\R/)

      {ax, ", Y" <> a} = Integer.parse(a)
      {ay, _} = Integer.parse(a)

      {bx, ", Y" <> b} = Integer.parse(b)
      {by, _} = Integer.parse(b)

      {px, ", Y=" <> prize} = Integer.parse(prize)
      {py, _} = Integer.parse(prize)

      {ax, ay, bx, by, px, py}
    end)
  end

  defp solve_1(claw_machines) do
    claw_machines
    |> Enum.map(&insert_tokens/1)
    |> Enum.sum()
    |> round()
  end

  defp solve_2(claw_machines) do
    claw_machines
    |> Enum.map(&insert_tokens(&1, 10_000_000_000_000))
    |> Enum.sum()
  end

  defp insert_tokens({ax, ay, bx, by, px, py}, offset \\ 0) do
    px = px + offset
    py = py + offset

    a_tokens = (bx * py - by * px) / (ay * bx - ax * by)
    b_tokens = (px - a_tokens * ax) / bx
    tokens = 3 * a_tokens + b_tokens

    if tokens > 0 and
        rem(bx * py - by * px, ay * bx - ax * by) == 0 and
        rem(round(px - a_tokens * ax), bx) == 0 do
      round(tokens)
    else
      0
    end
  end
end
