defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  defp deps do
    [
      {:exla, "~> 0.10.0"},
      {:jason, "~> 1.4"},
      {:memoize, "~> 1.4"},
      {:nx, "~> 0.10.0"}
    ]
  end
end
