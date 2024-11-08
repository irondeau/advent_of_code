defmodule AdventOfCode.Helpers.Graph.Edge do
  alias __MODULE__

  alias AdventOfCode.Helpers.Graph

  @enforce_keys [:v1, :v2]
  defstruct v1: nil, v2: nil, weight: 1

  @type t :: %__MODULE__{
    v1: Graph.vertex(),
    v2: Graph.vertex(),
    weight: number()
  }

  @spec new(Graph.vertex(), Graph.vertex(), Keyword.t()) :: t()
  def new(v1, v2, opts \\ []) when is_list(opts) do
    %Edge{
      v1: v1,
      v2: v2,
    }
    |> Map.merge(Enum.into(opts, %{}))
  end
end
