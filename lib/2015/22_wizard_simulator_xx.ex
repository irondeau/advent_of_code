defmodule AdventOfCode.Y2015.D22 do
  use AdventOfCode.Puzzle, year: 2015, day: 22

  alias AdventOfCode.Helpers.PQ

  @spells %{
    magic_missile: 53,
    drain: 73,
    shield: 113,
    poison: 173,
    recharge: 229
  }

  defmodule Entity do
    @enforce_keys [:hp, :mp, :ar]
    defstruct hp: nil, mp: nil, ar: nil, ap: 0, effects: []

    def new(hp, mp \\ 0, ar \\ 0), do: %Entity{hp: hp, mp: mp, ar: ar}

    def gain_health(%Entity{} = entity, hp), do: %{entity | hp: entity.hp + hp}

    def take_damage(%Entity{} = entity, damage), do: %{entity | hp: entity.hp - max(damage - entity.ap, 1)}

    def spend_mana(%Entity{} = entity, mp), do: %{entity | mp: entity.mp - mp}

    def add_effect(%Entity{} = entity, duration, effect_fn)
        when is_integer(duration) and is_function(effect_fn, 1) do
      %{entity | effects: [{duration, effect_fn} | entity.effects]}
    end

    def has_effect?(%Entity{} = entity, effect) when is_atom(effect) do
      entity.effects
      |> Enum.any?(fn {_duration, effect_fn} ->
        match?({:name, ^effect}, Function.info(effect_fn, :name))
      end)
    end

    def tick(%Entity{} = entity) do
      entity
      |> apply_effects()
      |> update_in([Access.key!(:effects)], fn effects ->
        effects
        |> update_in([Access.all(), Access.elem(0)], &(&1 - 1))
        |> Enum.reject(&elem(&1, 0) == 0)
      end)
    end

    defp apply_effects(%Entity{} = entity) do
      entity.effects
      |> Enum.reduce(%{entity | ap: 0}, fn {_, e_fn}, entity ->
        e_fn.(entity)
      end)
    end

    def shield(%Entity{ap: ap} = entity) do
      %{entity | ap: ap + 7}
    end

    def poison(%Entity{hp: hp} = entity) do
      %{entity | hp: hp - 3}
    end

    def recharge(%Entity{mp: mp} = entity) do
      %{entity | mp: mp + 101}
    end
  end

  @impl true
  def title, do: "Wizard Simulator 20XX"

  @impl true
  def solve(input) do
    {solve_1(input), solve_2(input)}
  end

  @impl true
  def parse(input) do
    boss_stats =
      Regex.named_captures(~r/Hit Points: (?<hp>\d+)\RDamage: (?<ar>\d+)/, input)
      |> Enum.map(fn {key, value} -> {String.to_atom(key), String.to_integer(value)} end)
      |> Enum.into(%{})

    player = Entity.new(50, 500)
    boss = Entity.new(boss_stats.hp, 0, boss_stats.ar)

    {player, boss}
  end

  defp solve_1({player, boss}) do
    turn_queue =
      PQ.new(fn {c1, _p1, _b1}, {c2, _p2, _b2} -> c1 < c2 end)
      |> PQ.push({0, player, boss})

    fight(turn_queue)
  end

  defp solve_2({player, boss}) do
    turn_queue =
      PQ.new(fn {c1, _p1, _b1}, {c2, _p2, _b2} -> c1 < c2 end)
      |> PQ.push({0, player, boss})

    fight(turn_queue, difficulty: :hard)
  end

  defp cast(subject, target, spell) when is_atom(spell) do
    subject = Entity.spend_mana(subject, @spells[spell])

    case spell do
      :magic_missile ->
        {subject, Entity.take_damage(target, 4)}
      :drain ->
        {Entity.gain_health(subject, 2), Entity.take_damage(target, 2)}
      :shield ->
        {Entity.add_effect(subject, 6, &Entity.shield/1), target}
      :poison ->
        {subject, Entity.add_effect(target, 6, &Entity.poison/1)}
      :recharge ->
        {Entity.add_effect(subject, 5, &Entity.recharge/1), target}
    end
  end

  defp fight(turn_queue, opts \\ [difficulty: :easy]) do
    with {{cost, player, boss}, turn_queue} <- PQ.pop(turn_queue) do
      player =
        if opts[:difficulty] == :hard do
          Entity.take_damage(player, 1)
        else
          player
        end

      # player turn
      player = Entity.tick(player)
      boss = Entity.tick(boss)

      cond do
        player.hp <= 0 or player.mp < 0 -> fight(turn_queue, opts)
        boss.hp <= 0 -> cost
        true ->
          @spells
          |> Enum.reject(fn {spell, spell_cost} ->
            Entity.has_effect?(player, spell)
            or Entity.has_effect?(boss, spell)
            or spell_cost > player.mp
          end)
          |> Enum.reduce_while(turn_queue, fn {spell, spell_cost}, turn_queue ->
            {player, boss} = cast(player, boss, spell)

            # boss turn
            player = Entity.tick(player)
            boss = Entity.tick(boss)

            cond do
              player.hp <= 0 or player.mp < 0 -> {:halt, fight(turn_queue, opts)}
              boss.hp <= 0 -> {:halt, spell_cost + cost}
              true ->
                player = Entity.take_damage(player, boss.ar)
                next = {spell_cost + cost, player, boss}
                {:cont, PQ.push(turn_queue, next)}
            end
          end)
          |> case do
            %PQ{} = turn_queue -> fight(turn_queue, opts)
            result -> result
          end
      end
    else
      {nil, _} ->
        raise "unable to find solution"
    end
  end
end
