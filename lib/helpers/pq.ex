defmodule AdventOfCode.Helpers.PQ do
  alias __MODULE__

  defstruct heap: nil, comparator: &Kernel.</2

  @typedoc "A pairing heap."
  @type heap :: %{
          node: term(),
          subheaps: [heap()]
        }

  @typedoc "A priority queue."
  @type t :: %__MODULE__{
          heap: heap(),
          comparator: (term(), term() -> boolean())
        }

  @spec empty?(t()) :: boolean()
  def empty?(%PQ{} = pq), do: pq.heap == nil

  @spec merge(t(), t()) :: t()
  def merge(%PQ{heap: nil}, pq), do: pq
  def merge(pq, %PQ{heap: nil}), do: pq

  def merge(%PQ{comparator: cmp_1}, %PQ{comparator: cmp_2}) when cmp_1 != cmp_2,
    do: raise(ArgumentError, message: "comparator functions do not match")

  def merge(%PQ{} = pq_1, %PQ{} = pq_2) do
    %PQ{
      heap: meld(pq_1.heap, pq_2.heap, pq_1.comparator),
      comparator: pq_1.comparator
    }
  end

  @doc """
  Returns a new empty priority queue.

  ## Examples

      iex> PQ.new()
      %PQ{}

  """
  @spec new() :: t()
  def new(), do: %PQ{}
  def new(comparator) when is_function(comparator, 2), do: %PQ{comparator: comparator}

  @spec peek(t()) :: term()
  def peek(pq, default \\ nil)
  def peek(%PQ{heap: nil}, default), do: default
  def peek(%PQ{heap: %{node: item}}, _default), do: item

  @spec pop(t()) :: {term(), t()}
  def pop(pq, default \\ nil)
  def pop(%PQ{heap: nil} = pq, default), do: {default, pq}

  def pop(%PQ{heap: %{node: item, subheaps: []}, comparator: comparator}, _default),
    do: {item, %PQ{comparator: comparator}}

  def pop(%PQ{heap: %{node: item, subheaps: [subheap]}, comparator: comparator}, _default),
    do: {item, %PQ{heap: subheap, comparator: comparator}}

  def pop(%PQ{heap: %{node: item, subheaps: subheaps}, comparator: comparator}, _default) do
    heap =
      subheaps
      |> Enum.chunk_every(2)
      |> Enum.map(fn pair ->
        with [heap_1, heap_2] <- pair do
          meld(heap_1, heap_2, comparator)
        else
          [heap] -> heap
        end
      end)
      |> Enum.reverse()
      |> Enum.reduce(&(meld(&1, &2, comparator)))

    {item, %PQ{heap: heap, comparator: comparator}}
  end

  @spec push(t(), term()) :: t()
  def push(%PQ{} = pq, item), do: merge(pq, leaf(item, pq.comparator))

  defp leaf(item, comparator), do: %PQ{heap: %{node: item, subheaps: []}, comparator: comparator}

  defp meld(heap_1, heap_2, comparator) do
    if comparator.(heap_1.node, heap_2.node) do
      %{node: heap_1.node, subheaps: [heap_2 | heap_1.subheaps]}
    else
      %{node: heap_2.node, subheaps: [heap_1 | heap_2.subheaps]}
    end
  end
end
