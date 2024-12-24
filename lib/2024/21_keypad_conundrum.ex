defmodule AdventOfCode.Y2024.D21 do
  use AdventOfCode.Puzzle, year: 2024, day: 21
  use Memoize

  @impl true
  def title, do: "Keypad Conundrum"

  @impl true
  def solve(input) do
    {solve(input, 2), solve(input, 25)}
  end

  @impl true
  def parse(input) do
    keycodes =
      input
      |> String.split(~r/\R/)
      |> Enum.map(fn keycode ->
        keycode
        |> String.graphemes()
        |> Enum.map(fn
          <<button>> when button in ?0..?9 -> String.to_integer(<<button>>)
          "A" -> :a
        end)
      end)

    dpad =
      %{
        up: %{down: :down, right: :a},
        down: %{up: :up, left: :left, right: :right},
        left: %{right: :down},
        right: %{left: :down, up: :a},
        a: %{left: :up, down: :right}
      }

    numpad =
      %{
        0 => %{up: 2, right: :a},
        1 => %{up: 4, right: 2},
        2 => %{up: 5, down: 0, left: 1, right: 3},
        3 => %{up: 6, down: :a, left: 2},
        4 => %{up: 7, down: 1, right: 5},
        5 => %{up: 8, down: 2, left: 4, right: 6},
        6 => %{up: 9, down: 3, left: 5},
        7 => %{down: 4, right: 8},
        8 => %{down: 5, left: 7, right: 9},
        9 => %{down: 6, left: 8},
        :a => %{up: 3, left: 0}
      }

    {keycodes, dpad, numpad}
  end

  defp solve({keycodes, dpad, numpad}, dpad_count) do
    keypads = [numpad | List.duplicate(dpad, dpad_count)]

    keycodes
    |> Enum.map(fn keycode ->
      {scalar, _} =
        keycode
        |> Enum.join()
        |> Integer.parse()

      scalar * get_keychain(keypads, keycode)
    end)
    |> Enum.sum()
  end

  defmemop get_keychain([], buttons), do: length(buttons)

  defmemop get_keychain([next | keypads], buttons) do
    buttons
    |> Enum.chunk_while([], fn
      :a, acc -> {:cont, [:a | acc] |> Enum.reverse(), []}
      button, acc -> {:cont, [button | acc]}
    end, fn [] -> {:cont, []} end)
    |> Enum.map(fn button_chunk ->
      get_keychain(keypads, get_sequence(next, button_chunk))
    end)
    |> Enum.sum()
  end

  defp get_sequence(keypad, buttons, current \\ :a)

  defp get_sequence(_keypad, [], _current), do: []

  defp get_sequence(keypad, [next | buttons], current) do
    seq = dfs(keypad, current, next)

    seq ++ get_sequence(keypad, buttons, next)
  end

  defp dfs(keypad, button_1, button_2) do
    dfs(keypad, button_1, button_2, 1)
  end

  defp dfs(keypad, current, stop, turns_left, visited \\ [], directions \\ [])

  defp dfs(_keypad, _current, _stop, turns_left, _visited, _directions) when turns_left < 0,
    do: nil

  defp dfs(_keypad, current, current, _turns_left, _visited, directions),
    do: Enum.reverse([:a | directions])

  defp dfs(keypad, current, stop, turns_left, visited, directions) do
    button = Map.fetch!(keypad, current)

    [:left, :up, :down, :right]
    |> Enum.find_value(fn direction ->
      case Map.get(button, direction) do
        nil -> nil
        next ->
          if next in visited do
            nil
          else
            turns_left =
              case directions do
                [hd | _] when hd != direction -> turns_left - 1
                _ -> turns_left
              end

            dfs(keypad, next, stop, turns_left, [current | visited], [direction | directions])
          end
      end
    end)
  end
end
