defmodule AdventOfCode.Helpers.PQ do
  alias __MODULE__

  defstruct heap: nil

  @typedoc "A pairing heap node containing an item and a priority."
  @type heap_node :: {term(), number()}

  @typedoc "A pairing heap."
  @type heap :: %{
          node: heap_node(),
          subheaps: [heap()]
        }

  @typedoc "A priority queue."
  @type t :: %__MODULE__{
          heap: heap()
        }

  @spec merge(t(), t()) :: t()
  def merge(%PQ{heap: nil}, pq), do: pq
  def merge(pq, %PQ{heap: nil}), do: pq
  def merge(%PQ{} = pq_1, %PQ{} = pq_2), do: %PQ{heap: meld(pq_1.heap, pq_2.heap)}

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
  def peek(%PQ{heap: nil}, default), do: default
  def peek(%PQ{heap: %{node: {item, _}}}, _default), do: item

  @spec pop(t()) :: {term(), t()}
  def pop(pq, default \\ nil)
  def pop(%PQ{heap: nil} = pq, default), do: {default, pq}
  def pop(%PQ{heap: %{node: {item, _}, subheaps: []}}, _default), do: {item, %PQ{}}

  def pop(%PQ{heap: %{node: {item, _}, subheaps: [subheap]}}, _default),
    do: {item, %PQ{heap: subheap}}

  def pop(%PQ{heap: %{node: {item, _}, subheaps: subheaps}}, _default) do
    heap =
      subheaps
      |> Enum.chunk_every(2)
      |> Enum.map(fn pair ->
        with [heap_1, heap_2] <- pair do
          meld(heap_1, heap_2)
        else
          [heap] -> heap
        end
      end)
      |> Enum.reverse()
      |> Enum.reduce(&meld/2)

    {item, %PQ{heap: heap}}
  end

  @spec push(t(), term(), number()) :: t()
  def push(%PQ{} = pq, item, priority), do: merge(pq, leaf(item, priority))

  defp leaf(item, priority), do: %PQ{heap: %{node: {item, priority}, subheaps: []}}

  defp meld(heap_1, heap_2) do
    if elem(heap_1.node, 1) <= elem(heap_2.node, 1) do
      %{node: heap_1.node, subheaps: [heap_2 | heap_1.subheaps]}
    else
      %{node: heap_2.node, subheaps: [heap_1 | heap_2.subheaps]}
    end
  end
end
