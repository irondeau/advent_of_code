defmodule AdventOfCode.Y2015.D15 do
  use AdventOfCode.Puzzle, year: 2015, day: 15

  require IEx

  @num_tsp 100
  @calorie_req 500

  @impl true
  def title, do: "Science for Hungry People"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    ingredients =
      input
      |> String.split(~r/\R/)
      |> Enum.map(fn line ->
        Regex.scan(~r/-?\d+/, line)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
      end)
      |> Nx.tensor()

    {num_ingredients, _} = Nx.shape(ingredients)

    for combination <- combinations(num_ingredients, @num_tsp) do
      combination_tensor =
        Nx.tensor(combination)
        |> Nx.new_axis(1)

      ingredients
      |> Nx.multiply(combination_tensor)
      |> Nx.sum(axes: [0])
      |> Nx.max(0)
      |> Nx.to_list()
    end
  end

  defp solve_1(recipe_totals) do
    for recipe_total <- recipe_totals do
      recipe_total
      |> Enum.drop(-1)
      |> Enum.product()
    end
    |> Enum.max()
  end

  defp solve_2(recipe_totals) do
    for recipe_total <- recipe_totals do
      if Enum.at(recipe_total, -1) == @calorie_req do
        recipe_total
        |> Enum.drop(-1)
        |> Enum.product()
      else
        0
      end
    end
    |> Enum.max()
  end

  defp combinations(1, num_tsp), do: [[num_tsp]]

  defp combinations(num_ingredients, num_tsp) do
    for tsp <- 0..num_tsp,
        combination <- combinations(num_ingredients - 1, num_tsp - tsp) do
      [tsp | combination]
    end
  end
end
