defmodule GraphBehaviour do
  alias AdventOfCode.Helpers.Graph.Edge

  @type vertex :: any()
  @type edge_map :: %{Reference.t() => Edge.t()}
  @type graph :: %{
          vertices: MapSet.t(vertex()),
          edges: edge_map()
        }

  @callback new() :: graph()

  @callback vertices(graph()) :: [vertex()]
  @callback edges(graph()) :: edge_map()
  @callback edges(graph(), vertex()) :: edge_map()
  @callback edges(graph(), vertex(), vertex()) :: edge_map()
  @callback neighbors(graph(), vertex()) :: [vertex()]

  @callback add_vertex(graph(), vertex()) :: graph()
  @callback add_vertices(graph(), [vertex()]) :: graph()
  @callback delete_vertex(graph(), vertex()) :: graph()
  @callback delete_vertices(graph(), [vertex()]) :: graph()

  @callback add_edge(graph(), vertex(), vertex(), Keyword.t()) :: graph()
  @callback add_edges(graph(), [{vertex(), vertex(), Keyword.t()}], Keyword.t()) :: graph()
  @callback delete_edge(graph(), Reference.t()) :: graph()
  @callback delete_edges(graph(), [Reference.t()]) :: graph()

  @callback dijkstra(graph(), vertex(), vertex()) :: [edge_map()]
  @callback get_paths(graph(), vertex(), vertex()) :: [[edge_map()]]
end

defmodule AdventOfCode.Helpers.Graph do
  defmacro __using__(_opts) do
    quote do
      @behaviour GraphBehaviour

      alias AdventOfCode.Helpers.Graph.Edge

      defstruct vertices: MapSet.new(), edges: %{}

      def new() do
        %__MODULE__{}
      end

      def vertices(%__MODULE__{} = graph) do
        MapSet.to_list(graph.vertices)
      end

      def edges(%__MODULE__{} = graph), do: graph.edges

      def edges(%__MODULE__{} = graph, vertex) do
        Map.filter(graph.edges, fn {_, edge} ->
          edge.v1 == vertex or edge.v2 == vertex
        end)
      end

      def edges(%__MODULE__{} = graph, v1, v2) do
        Map.filter(graph.edges, fn {_, edge} ->
          (edge.v1 == v1 and edge.v2 == v2) or (edge.v1 == v2 and edge.v2 == v1)
        end)
      end

      def neighbors(%__MODULE__{} = graph, vertex) do
        graph
        |> edges(vertex)
        |> Enum.flat_map(fn {_, %Edge{v1: v1, v2: v2}} ->
          [v1, v2]
        end)
        |> Enum.uniq()
        |> Enum.reject(& &1 == vertex)
      end

      def add_vertex(%__MODULE__{} = graph, vertex) do
        %{graph | vertices: MapSet.put(graph.vertices, vertex)}
      end

      def add_vertices(%__MODULE__{} = graph, vertices) do
        %{graph | vertices: MapSet.union(graph.vertices, MapSet.new(vertices))}
      end

      def delete_vertex(%__MODULE__{} = graph, vertex) do
        %{graph | vertices: MapSet.delete(graph.vertices, vertex)}
        |> __MODULE__.delete_edges(vertex)
      end

      def delete_vertices(%__MODULE__{} = graph, vertices) when is_list(vertices) do
        %{graph | vertices: MapSet.difference(graph.vertices, MapSet.new(vertices))}
        |> then(fn graph ->
          Enum.reduce(vertices, graph, fn vertex, graph ->
            __MODULE__.delete_edges(graph, vertex)
          end)
        end)
      end

      def add_edge(%__MODULE__{} = graph, v1, v2, opts \\ []) when is_list(opts) do
        graph
        |> __MODULE__.add_vertex(v1)
        |> __MODULE__.add_vertex(v2)
        |> update_in([Access.key!(:edges)], fn edges ->
          Map.put(edges, make_ref(), Edge.new(v1, v2, opts))
        end)
      end

      def add_edges(%__MODULE__{} = graph, edges, opts \\ [add_vertices: true]) when is_list(edges) and is_list(opts) do
        edges
        |> Enum.filter(fn edge ->
          opts[:add_vertices]
          or MapSet.subset?(MapSet.new([elem(edge, 0), elem(edge, 1)]), graph.vertices)
        end)
        |> Enum.reduce(graph, fn edge, graph ->
          apply(__MODULE__, :add_edge, [graph | Tuple.to_list(edge)])
        end)
      end

      def delete_edge(%__MODULE__{} = graph, edge) when is_reference(edge) do
        %{graph | edges: Map.delete(graph.edges, edge)}
      end

      def delete_edges(%__MODULE__{} = graph, edges) when is_list(edges) do
        %{graph | edges: Map.drop(graph.edges, edges)}
      end

      def delete_edges(%__MODULE__{} = graph, vertex) do
        %{graph | edges: Map.reject(graph.edges, fn {_, edge} ->
          edge.v1 == vertex or edge.v2 == vertex
        end)}
      end

      defoverridable GraphBehaviour
    end
  end
end
