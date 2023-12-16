defmodule AdventOfCode.Day04 do
  def part1(args) do
    args
      |> String.split("\n")
      |> Enum.filter(fn line -> String.length(line) > 0 end)
      |> Enum.map(fn line ->
        [_, numbers] = String.split(line, ":")
        [winning_numbers, picked_numbers] = String.split(numbers, "|")
          |> Enum.map(&String.trim/1)
          |> Enum.map(& String.split(&1, " "))
          |> Enum.map(& Enum.map(&1, fn x ->
            case Integer.parse(x) do
              {num, ""} -> num
              _ -> nil
            end
          end))

          matches = MapSet.intersection(MapSet.new(winning_numbers), MapSet.new(picked_numbers))
            |> Enum.filter(fn x -> x != nil end)

          matches_size = length(matches)

          if matches_size == 0, do: 0, else: :math.pow(2, matches_size - 1) |> round
      end)
      |> Enum.sum
  end

  def part2(args) do
    cards = args
      |> String.split("\n")
      |> Enum.filter(fn line -> String.length(line) > 0 end)
      |> Enum.reduce(%{}, fn line, acc ->
        [raw_id, numbers] = String.split(line, ":")
        {id, ""} = String.split(raw_id, " ") |> List.last |> Integer.parse
        [winning_numbers, picked_numbers] = String.split(numbers, "|")
          |> Enum.map(&String.trim/1)
          |> Enum.map(& String.split(&1, " "))
          |> Enum.map(& Enum.map(&1, fn x ->
            case Integer.parse(x) do
              {num, ""} -> num
              _ -> nil
            end
          end))

          match_size = MapSet.intersection(MapSet.new(winning_numbers), MapSet.new(picked_numbers))
            |> Enum.filter(fn x -> x != nil end)
            |> length

          if match_size == 0, do: acc, else: Map.put(acc, id, Enum.to_list(if match_size == 1, do: id+1..match_size, else: id..match_size))
      end)

    IO.inspect(cards, charlists: :as_lists)

    Enum.reduce(cards, 0, fn {_, value}, acc ->
      ids = Enum.map(value, fn x -> length(Map.get(cards, x, [])) end)
      IO.inspect(ids)
      acc + length(value) + Enum.sum(ids)
    end)
  end
end
