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
            x["red"] > @max_red or
            x["green"] > @max_green or
            x["blue"] > @max_blue
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

        Enum.max_by(games, & &1["red"])["red"] *
        Enum.max_by(games, & &1["green"])["green"] *
        Enum.max_by(games, & &1["blue"])["blue"]
      end)
     |> Enum.sum()
  end

  defp parse_game(game_str) do
    game_str
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.reduce(%{
        "red" => 0,
        "green" => 0,
        "blue" => 0
      }, fn x, acc ->
        [value, key] = String.split(x, " ")
        Map.put(acc, key, value
          |> String.trim
          |> Integer.parse
          |> elem(0))
      end)
  end
end
