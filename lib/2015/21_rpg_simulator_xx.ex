defmodule AdventOfCode.Y2015.D21 do
  use AdventOfCode.Puzzle, year: 2015, day: 21

  @item_shop %{
    # weapons
    dagger: %{cost: 8, damage: 4, armor: 0},
    shortsword: %{cost: 10, damage: 5, armor: 0},
    warhammer: %{cost: 25, damage: 6, armor: 0},
    longsword: %{cost: 40, damage: 7, armor: 0},
    greataxe: %{cost: 74, damage: 8, armor: 0},

    # armor
    leather: %{cost: 13, damage: 0, armor: 1},
    chainmail: %{cost: 31, damage: 0, armor: 2},
    splintmail: %{cost: 53, damage: 0, armor: 3},
    bandedmail: %{cost: 75, damage: 0, armor: 4},
    platemail: %{cost: 102, damage: 0, armor: 5},

    # rings
    damage_1: %{cost: 25, damage: 1, armor: 0},
    damage_2: %{cost: 50, damage: 2, armor: 0},
    damage_3: %{cost: 100, damage: 3, armor: 0},
    defense_1: %{cost: 20, damage: 0, armor: 1},
    defense_2: %{cost: 40, damage: 0, armor: 2},
    defense_3: %{cost: 80, damage: 0, armor: 3}
  }

  # @player_stats %{hp: 100, damage: 0, armor: 0}

  @impl true
  def title, do: "RPG Simulator 20XX"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    Regex.named_captures(~r/Hit Points: (?<hp>\d+)\RDamage: (?<damage>\d+)\RArmor: (?<armor>\d+)/, input)
    |> Enum.map(fn {key, value} -> {String.to_atom(key), String.to_integer(value)} end)
    |> Enum.into(%{})
  end

  defp solve_1(_boss_stats) do
    @item_shop
    |> Map.take([:longsword, :chainmail, :defense_1])
    |> Map.values()
    |> get_in([Access.all(), :cost])
    |> Enum.sum()
  end

  defp solve_2(_boss_stats) do
    @item_shop
    |> Map.take([:dagger, :damage_2, :damage_3])
    |> Map.values()
    |> get_in([Access.all(), :cost])
    |> Enum.sum()
  end
end
