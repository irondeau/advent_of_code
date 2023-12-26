defmodule AdventOfCode.Helpers.PQ do
  alias __MODULE__

  defstruct forest: []

  @typedoc "A binomial tree node containing an item and a priority."
  @type tree_node :: {term(), number()}

  @typedoc "A binomial tree."
  @type tree :: {tree_node(), [tree()]}

  @typedoc "A binomial tree rank."
  @type rank :: non_neg_integer()

  @typedoc "A ranked binomial tree."
  @type ranked_tree :: %{
    tree: tree(),
    rank: rank()
  }

  @typedoc "A priority queue."
  @type t :: %__MODULE__{
    forest: [ranked_tree()]
  }

  @spec merge(t(), t()) :: t()
  def merge(%PQ{forest: []}, pq), do: pq
  def merge(pq, %PQ{forest: []}), do: pq

  def merge(%PQ{forest: forest_1}, %PQ{forest: forest_2}) do
    %PQ{forest: meld(forest_1, forest_2)}
  end

  @doc """
  Returns a new empty priority queue.

  ## Examples

      iex> PQ.new()
      %PQ{}

  """
  @spec new() :: t()
  def new(), do: %PQ{}

  @spec peek(t()) :: term()
  def peek(pq, default \\ nil)
  def peek(%PQ{forest: []}, default), do: default

  def peek(%PQ{forest: forest}, _default) do
    forest
    |> Enum.sort_by(&root_priority/1, :asc)
    |> List.first()
    |> get_in([Access.key(:tree), Access.elem(0), Access.elem(0)])
  end

  @spec pop(t()) :: {term(), t()}
  def pop(pq, default \\ nil)
  def pop(%PQ{forest: []} = pq, default), do: {default, pq}

  def pop(%PQ{forest: forest} = pq, _default) do
    rt_min_idx =
      forest
      |> Enum.with_index()
      |> Enum.sort_by(&(elem(&1, 0) |> root_priority()), :asc)
      |> List.first()
      |> elem(1)

    {%{tree: {{rt_min_item, _}, rt_min_children}}, rt_rest} =
      List.pop_at(forest, rt_min_idx)

    forest =
      rt_min_children
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.map(fn {tree, i} -> %{tree: tree, rank: i} end)
      |> meld(rt_rest)

    {rt_min_item,
     %{pq | forest: forest}}
  end

  @spec push(t(), term(), number()) :: t()
  def push(%PQ{forest: forest} = pq, item, priority) do
    %{pq | forest: ins(forest, singleton(item, priority))}
  end

  @spec size(t()) :: non_neg_integer()
  def size(%PQ{forest: forest}) do
    forest
    |> Enum.map(fn %{rank: rank} -> 2 ** rank end)
    |> Enum.sum()
  end

  defp singleton(item, priority), do: %{tree: {{item, priority}, []}, rank: 0}

  def link(
      %{tree: {rt_root_1, rt_children_1} = rt_tree_1, rank: rt_rank_1},
      %{tree: {rt_root_2, rt_children_2} = rt_tree_2, rank: rt_rank_2}) do
    if elem(rt_root_1, 1) <= elem(rt_root_2, 1) do
      %{tree: {rt_root_1, [rt_tree_2 | rt_children_1]}, rank: rt_rank_1 + 1}
    else
      %{tree: {rt_root_2, [rt_tree_1 | rt_children_2]}, rank: rt_rank_2 + 1}
    end
  end

  defp ins([], ranked_tree), do: [ranked_tree]

  defp ins(forest, ranked_tree) do
    if ranked_tree.rank < hd(forest).rank do
      [ranked_tree | forest]
    else
      ins(
        tl(forest),
        link(ranked_tree, hd(forest))
      )
    end
  end

  def meld([], forest), do: forest
  def meld(forest, []), do: forest

  def meld([rt_1 | rt_rest_1] = forest_1, [rt_2 | rt_rest_2] = forest_2) do
    cond do
      rt_1.rank < rt_2.rank ->
        [rt_1 | meld(rt_rest_1, forest_2)]

      rt_2.rank < rt_1.rank ->
        [rt_2 | meld(forest_1, rt_rest_2)]

      true ->
        ins(meld(rt_rest_1, rt_rest_2), link(rt_1, rt_2))
    end
  end

  defp root_priority(ranked_tree) do
    ranked_tree
    |> get_in([
      Access.key(:tree),
      Access.elem(0),
      Access.elem(1)
    ])
  end
end
