defmodule AdventOfCode.Y2024.D15 do
  use AdventOfCode.Puzzle, year: 2024, day: 15

  defmodule Bound do
    @enforce_keys [:x, :y, :width, :height]
    defstruct [:x, :y, :width, :height, :label]

    def new(x, y, label) when is_integer(x) and is_integer(y),
      do: %Bound{x: x, y: y, width: 1, height: 1, label: label}

    def new(x, y, width, height, label) when is_integer(x) and is_integer(y) and is_integer(width) and is_integer(height),
    do: %Bound{x: x, y: y, width: width, height: height, label: label}

    def intersect?(%Bound{} = bound_1, %Bound{} = bound_2) do
      bound_1.x < bound_2.x + bound_2.width and
      bound_1.x + bound_1.width > bound_2.x and
      bound_1.y < bound_2.y + bound_2.height and
      bound_1.y + bound_1.height > bound_2.y
    end

    def move(%Bound{y: y} = bound, "^"), do: %{bound | y: y - 1}
    def move(%Bound{x: x} = bound, ">"), do: %{bound | x: x + 1}
    def move(%Bound{y: y} = bound, "v"), do: %{bound | y: y + 1}
    def move(%Bound{x: x} = bound, "<"), do: %{bound | x: x - 1}
  end

  @impl true
  def title, do: "Warehouse Woes"

  @impl true
  def solve(input) do
    [warehouse, instrs] = String.split(input, ~r/\R\R/)

    warehouse_1 = parse_1(warehouse)
    warehouse_2 = parse_2(warehouse)

    instrs =
      instrs
      |> String.replace(~r/\R/, "")
      |> String.graphemes()

    {solve(warehouse_1, instrs), solve(warehouse_2, instrs)}
  end

  defp parse_1(warehouse) do
    warehouse
    |> String.split(~r/\R/)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reject(fn {char, _x} -> char == "." end)
      |> Enum.map(fn
        {"@", x} -> Bound.new(x, y, :robot)
        {"O", x} -> Bound.new(x, y, :box)
        {"#", x} -> Bound.new(x, y, :wall)
      end)
    end)
  end

  defp parse_2(warehouse) do
    warehouse
    |> String.split(~r/\R/)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reject(fn {char, _x} -> char == "." end)
      |> Enum.map(fn
        {"@", x} -> Bound.new(x * 2, y, 1, 1, :robot)
        {"O", x} -> Bound.new(x * 2, y, 2, 1, :box)
        {"#", x} -> Bound.new(x * 2, y, 2, 1, :wall)
      end)
    end)
  end

  defp solve(warehouse, []) do
    warehouse
    |> Enum.filter(fn %Bound{label: label} -> label == :box end)
    |> Enum.map(fn %Bound{x: x, y: y} -> 100 * y + x end)
    |> Enum.sum()
  end

  defp solve(warehouse, [instr | instrs]) do
    robot = Enum.find(warehouse, fn %Bound{label: label} -> label == :robot end)

    try do
      warehouse
      |> push([robot], instr)
      |> solve(instrs)
    rescue
      RuntimeError -> solve(warehouse, instrs)
    end
  end

  defp push(warehouse, [], _instr), do: warehouse

  defp push(warehouse, bounds, instr) do
    moved_bounds = Enum.map(bounds, &Bound.move(&1, instr))
    next_warehouse = Enum.reject(warehouse, &(&1 in bounds))

    # get tiles which collide when performing the current move
    next_bounds =
      next_warehouse
      |> Enum.filter(fn bound ->
        Enum.any?(moved_bounds, &Bound.intersect?(&1, bound))
      end)

    if Enum.any?(next_bounds, &match?(%Bound{label: :wall}, &1)),
      do: raise "hit a wall"

    push(next_warehouse, next_bounds, instr) ++ moved_bounds
  end
end
