defmodule AdventOfCode.Helpers.PQ do
  alias __MODULE__

  defstruct forest: []

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
    |> Enum.min_by(&root_priority/1)
    |> root_item()
  end

  @spec pop(t()) :: {term(), t()}
  def pop(pq, default \\ nil)
  def pop(%PQ{forest: []} = pq, default), do: {default, pq}

  def pop(%PQ{forest: forest} = pq, _default) do
    {%{tree: {{min_item, _}, min_children}}, min_idx} =
      forest
      |> Enum.with_index()
      |> Enum.min_by(&(elem(&1, 0) |> root_priority()))

    {min_singletons, min_rest} =
      min_children
      |> Enum.split_with(fn child -> child.rank == 0 end)

    forest =
      forest
      |> List.delete_at(min_idx)
      |> meld(min_rest)

    pq =
      min_singletons
      |> Enum.reduce(%{pq | forest: forest}, fn %{tree: {{item, priority}, []}}, pq ->
        push(pq, item, priority)
      end)

    {min_item, pq}
  end

  @spec push(t(), term(), number()) :: t()
  def push(%PQ{forest: [rt_1 | [rt_2 | rest]] = forest} = pq, item, priority) do
    if rt_1.rank == rt_2.rank do
      %{pq | forest: [skew_link(singleton(item, priority), rt_1, rt_2) | rest]}
    else
      %{pq | forest: [singleton(item, priority) | forest]}
    end
  end

  def push(%PQ{forest: forest} = pq, item, priority) do
    %{pq | forest: [singleton(item, priority) | forest]}
  end

  @spec size(t()) :: non_neg_integer()
  def size(%PQ{forest: forest}) do
    forest
    |> Enum.map(fn %{rank: rank} -> 2 ** rank end)
    |> Enum.sum()
  end

  defp singleton(item, priority), do: %{tree: {{item, priority}, []}, rank: 0}

  defp link(
      %{tree: {rt_root_1, rt_children_1}, rank: rt_rank_1} = rt_1,
      %{tree: {rt_root_2, rt_children_2}, rank: rt_rank_2} = rt_2) do
    if root_priority(rt_1) <= root_priority(rt_2) do
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
      root_priority(rt_1) <= root_priority(rt_0) and
          root_priority(rt_1) <= root_priority(rt_2) ->
        %{tree: {rt_root_1, [rt_0 | [rt_2 | rt_children_1]]}, rank: rt_rank_1 + 1}

      root_priority(rt_2) <= root_priority(rt_0) and
          root_priority(rt_2) <= root_priority(rt_1) ->
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

  defp root_item(ranked_tree) do
    ranked_tree
    |> get_in([
      Access.key(:tree),
      Access.elem(0),
      Access.elem(0)
    ])
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
