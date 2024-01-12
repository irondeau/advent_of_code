defmodule AdventOfCode.Helpers.PQ do
  alias __MODULE__

  defstruct forest: [], root: nil

  @typedoc "A binomial tree node containing an item and a priority."
  @type tree_node :: {term(), number()}

  @typedoc "A binomial tree rank."
  @type rank :: non_neg_integer()

  @typedoc "A ranked binomial tree."
  @type ranked_tree :: %{
    tree: {tree_node(), [ranked_tree()]},
    rank: rank()
  }

  @typedoc "A priority queue."
  @type t :: %__MODULE__{
    forest: [ranked_tree()],
    root: tree_node() | nil
  }

  @spec merge(t(), t()) :: t()
  def merge(%PQ{root: nil}, pq), do: pq
  def merge(pq, %PQ{root: nil}), do: pq

  def merge(
      %PQ{root: root_1, forest: forest_1},
      %PQ{root: root_2, forest: forest_2}) do
    if root_1 <= root_2 do
      %PQ{root: root_1, forest: meld(forest_1, forest_2) |> ins(singleton(root_2))}
    else
      %PQ{root: root_2, forest: meld(forest_1, forest_2) |> ins(singleton(root_1))}
    end
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
  def peek(%PQ{root: nil}, default), do: default
  def peek(%PQ{root: {item, _}}, _default), do: item

  @spec pop(t()) :: {term(), t()}
  def pop(pq, default \\ nil)
  def pop(%PQ{root: nil} = pq, default), do: {default, pq}
  def pop(%PQ{forest: [], root: {item, _}}, _default), do: {item, %PQ{}}

  def pop(pq, _default) do
    {%{tree: {next_root, next_children}}, next_idx} =
      pq.forest
      |> Enum.with_index()
      |> Enum.min_by(&(elem(&1, 0) |> priority()))

    {next_singletons, next_rest} =
      next_children
      |> Enum.split_with(fn child -> child.rank == 0 end)

    forest =
      pq.forest
      |> List.delete_at(next_idx)
      |> meld(next_rest)

    next_pq =
      next_singletons
      |> Enum.reduce(%{pq | forest: forest}, fn %{tree: {{item, priority}, []}}, pq ->
        push(pq, item, priority)
      end)
      |> Map.put(:root, next_root)

    {elem(pq.root, 0), next_pq}
  end

  @spec push(t(), term(), number()) :: t()
  def push(%PQ{root: nil} = pq, item, priority), do: %{pq | root: {item, priority}}

  def push(pq, item, priority) do
    {root, node} =
      if priority <= elem(pq.root, 1) do
        {{item, priority}, singleton(pq.root)}
      else
        {pq.root, singleton({item, priority})}
      end

    with [rt_1 | [rt_2 | rt_rest]] <- pq.forest,
        true <- rt_1.rank == rt_2.rank do
      %{pq | forest: [skew_link(node, rt_1, rt_2) | rt_rest], root: root}
    else
      _ -> %{pq | forest: [node | pq.forest], root: root}
    end
  end

  defp singleton(node), do: %{tree: {node, []}, rank: 0}

  defp link(
      %{tree: {rt_root_1, rt_children_1}, rank: rt_rank_1} = rt_1,
      %{tree: {rt_root_2, rt_children_2}, rank: rt_rank_2} = rt_2) do
    if priority(rt_1) <= priority(rt_2) do
      %{tree: {rt_root_1, [rt_2 | rt_children_1]}, rank: rt_rank_1 + 1}
    else
      %{tree: {rt_root_2, [rt_1 | rt_children_2]}, rank: rt_rank_2 + 1}
    end
  end

  defp skew_link(
      %{tree: {rt_root_0, _}} = rt_0,
      %{tree: {rt_root_1, rt_children_1}, rank: rt_rank_1} = rt_1,
      %{tree: {rt_root_2, rt_children_2}, rank: rt_rank_2} = rt_2) do
    cond do
      priority(rt_1) <= priority(rt_0) and
          priority(rt_1) <= priority(rt_2) ->
        %{tree: {rt_root_1, [rt_0 | [rt_2 | rt_children_1]]}, rank: rt_rank_1 + 1}

      priority(rt_2) <= priority(rt_0) and
          priority(rt_2) <= priority(rt_1) ->
        %{tree: {rt_root_2, [rt_0 | [rt_1 | rt_children_2]]}, rank: rt_rank_2 + 1}

      true ->
        %{tree: {rt_root_0, [rt_1 | [rt_2 | []]]}, rank: rt_rank_1 + 1}
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

  defp uniquify([]), do: []
  defp uniquify([ranked_tree | forest]), do: ins(forest, ranked_tree)

  defp meld_unique([], forest), do: forest
  defp meld_unique(forest, []), do: forest

  defp meld_unique([rt_1 | rt_rest_1] = forest_1, [rt_2 | rt_rest_2] = forest_2) do
    cond do
      rt_1.rank < rt_2.rank ->
        [rt_1 | meld_unique(rt_rest_1, forest_2)]

      rt_2.rank < rt_1.rank ->
        [rt_2 | meld_unique(forest_1, rt_rest_2)]

      true ->
        ins(meld_unique(rt_rest_1, rt_rest_2), link(rt_1, rt_2))
    end
  end

  defp meld(forest_1, forest_2), do: meld_unique(uniquify(forest_1), uniquify(forest_2))

  defp priority(%{tree: {{_, priority}, _}}), do: priority
end
