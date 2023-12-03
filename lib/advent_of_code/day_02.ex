defmodule AdventOfCode.Day02 do
  @max_red 12
  @max_green 13
  @max_blue 14

  def part1(args) do
    args
      |> String.split("\n")
      |> Enum.filter(& String.length(&1) > 0)
      |> Enum.map(fn line ->
        [raw_id, games] = String.split(line, ":")
        parsed_id = raw_id
          |> String.slice(5..-1)
          |> Integer.parse()
          |> elem(0)

        impossible_count = String.split(games, ";")
          |> Enum.map(&parse_game/1)
          |> Enum.filter(fn x ->
            Map.get(x, "red", 0) > @max_red or
            Map.get(x, "green", 0) > @max_green or
            Map.get(x, "blue", 0) > @max_blue
          end)
          |> Enum.count()

        if impossible_count > 0, do: 0, else: parsed_id
      end)
     |> Enum.sum()
  end

  def part2(args) do
    args
      |> String.split("\n")
      |> Enum.filter(& String.length(&1) > 0)
      |> Enum.map(fn line ->
        games = line
          |> String.split(":")
          |> List.last
          |> String.split(";")
          |> Enum.map(&parse_game/1)

        Map.get(Enum.max_by(games, & Map.get(&1, "red", 0)), "red", 0) *
        Map.get(Enum.max_by(games, & Map.get(&1, "green", 0)), "green", 0) *
        Map.get(Enum.max_by(games, & Map.get(&1, "blue", 0)), "blue", 0)
      end)
     |> Enum.sum()
  end

  defp parse_game(game_str) do
    game_str
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.reduce(%{}, fn x, acc ->
        [value, key] = String.split(x, " ")
        Map.put(acc, key, value
          |> String.trim
          |> Integer.parse
          |> elem(0))
      end)
  end
end
