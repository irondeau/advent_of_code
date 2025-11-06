defmodule AdventOfCode.Puzzle do
  @callback title() :: String.t()
  @callback parse(binary()) :: any()
  @callback solve(any()) :: any()

  defmacro __using__(opts) do
    quote bind_quoted: [year: opts[:year], day: opts[:day]] do
      require Logger
      @behaviour AdventOfCode.Puzzle

      def run() do
        Path.join([
          :code.priv_dir(:advent_of_code),
          "data",
          "inputs",
          "#{unquote(year)}",
          String.pad_leading("#{unquote(day)}", 2, "0") <> ".txt"
        ])
        |> File.read!()
        |> run()
      end

      def run(input) do
        Logger.info(
          "Year #{unquote(year)} Day #{String.pad_leading("#{unquote(day)}", 2, "0")}: #{title()}"
        )

        input
        |> parse()
        |> solve()
      end

      def parse(input), do: input

      defoverridable parse: 1
    end
  end
end
