defmodule Mix.AdventOfCode do
  def parse(args), do:
    OptionParser.parse(args,
      aliases: [
        y: :year,
        d: :day,
        t: :title
      ],
      strict: [
        help: :boolean,
        year: :integer,
        day: :integer,
        title: :string
      ]
    )
end
