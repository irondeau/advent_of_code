defmodule AdventOfCode.Y2023.D19 do
  use AdventOfCode.Puzzle, year: 2023, day: 19

  @impl true
  def title, do: "Aplenty"

  @impl true
  def solve(input) do
    input
    |> then(&({solve_1(&1), solve_2(&1)}))
  end

  @impl true
  def parse(input) do
    [workflows, parts] = String.split(input, ~r/\R\R/)

    workflows =
      workflows
      |> String.split(~r/\R/)
      |> Enum.reduce(%{}, fn workflow, acc ->
        [workflow, rules] = String.split(workflow, ~r/[{}]/, trim: true)

        rules =
          rules
          |> String.split(",")
          |> Enum.reduce([], fn rule, acc ->
             [parse_rule(rule) | acc]
          end)
          |> Enum.reverse()

        Map.put(acc, workflow, rules)
      end)

    parts =
      parts
      |> String.split(~r/\R/)
      |> Enum.map(fn part ->
        part
        |> String.split(~r/[{},]/, trim: true)
        |> Enum.map(&parse_category/1)
        |> Map.new()
      end)

    {workflows, parts}
  end

  defp solve_1({workflows, parts}) do
    parts
    |> Enum.filter(&(evaluate_1(workflows, &1)))
    |> Enum.map(fn part -> part |> Map.values() |> Enum.sum() end)
    |> Enum.sum()
  end

  defp solve_2({workflows, _parts}) do
    part = %{"x" => 1..4000, "m" => 1..4000, "a" => 1..4000, "s" => 1..4000}

    workflows
    |> evaluate_2(part)
    |> List.flatten()
    |> Enum.map(fn part ->
      part
      |> Map.values()
      |> Enum.map(&Range.size/1)
      |> Enum.product()
    end)
    |> Enum.sum()
  end

  defp parse_rule("A"), do: {:else, :accept}
  defp parse_rule("R"), do: {:else, :reject}

  defp parse_rule(<<category>> <> <<ieq>> <> rest) when category in ~c"xmas" and ieq in ~c"<>" do
    ieq_fun = if <<ieq>> == "<", do: &Kernel.</2, else: &Kernel.>/2

    case String.split(rest, ":") do
      [value, "A"] ->
        {<<category>>, {ieq_fun, String.to_integer(value), :accept}}

      [value, "R"] ->
        {<<category>>, {ieq_fun, String.to_integer(value), :reject}}

      [value, workflow] ->
        {<<category>>, {ieq_fun, String.to_integer(value), workflow}}
    end
  end

  defp parse_rule(workflow), do: {:else, workflow}

  defp parse_category(<<category>> <> "=" <> value) when category in ~c"xmas" do
    {<<category>>, String.to_integer(value)}
  end

  defp evaluate_1(workflows, part, workflow \\ "in") do
    case Map.get(workflows, workflow) do
      rules when is_list(rules) ->
        rules
        |> Enum.reduce_while(true, fn rule, acc ->
          case rule do
            {:else, :accept} -> {:halt, true}
            {:else, :reject} -> {:halt, false}
            {:else, next_workflow} -> {:halt, evaluate_1(workflows, part, next_workflow)}

            {category, {ieq_fun, value, then}} ->
              if ieq_fun.(Map.get(part, category), value) do
                case then do
                  :accept -> {:halt, true}
                  :reject -> {:halt, false}
                  next_workflow -> {:halt, evaluate_1(workflows, part, next_workflow)}
                end
              else
                {:cont, acc}
              end
          end
        end)

      _ ->
        raise ArgumentError
    end
  end

  defp evaluate_2(workflows, part, workflow \\ "in") do
    case Map.get(workflows, workflow) do
      rules when is_list(rules) ->
        rules
        |> Enum.reduce_while({[], part}, fn rule, {acc, part} ->
          case rule do
            {:else, :accept} -> {:halt, [part | acc]}
            {:else, :reject} -> {:halt, acc}
            {:else, next_workflow} -> {:halt, [evaluate_2(workflows, part, next_workflow) | acc]}

            {category, {ieq_fun, value, then}} ->
              category_range = Map.get(part, category)
              split_offset = if ieq_fun == &Kernel.>/2, do: 1, else: 0

              [lower_part, upper_part] =
                category_range
                |> Range.split(value - category_range.first + split_offset)
                |> Tuple.to_list()
                |> Enum.map(fn range -> Map.put(part, category, range) end)

              evaluate_fun = fn part ->
                case then do
                  :accept -> [part | acc]
                  :reject -> acc
                  next_workflow -> [evaluate_2(workflows, part, next_workflow) | acc]
                end
              end

              if ieq_fun == &Kernel.>/2 do
                {:cont, {evaluate_fun.(upper_part), lower_part}}
              else
                {:cont, {evaluate_fun.(lower_part), upper_part}}
              end
          end
        end)

      _ ->
        raise ArgumentError
    end
  end
end
