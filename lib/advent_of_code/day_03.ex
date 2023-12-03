defmodule AdventOfCode.Day03 do
  def part1(args) do
    lines = String.split(args, "\n")
    length = lines
      |> List.first
      |> String.length

    matrix = lines
      |> Enum.flat_map(&String.graphemes/1)
      |> Enum.map(fn x ->
        case Integer.parse(x) do
          {num, ""} -> num
          _ -> x
        end
      end)

    Enum.with_index(matrix)
      |> Enum.chunk_by(fn {value, _} -> is_integer(value) end)
      |> Enum.filter(fn x -> Enum.any?(x, fn {value, _} -> is_integer(value) end) end)
      |> Enum.filter(fn x -> Enum.any?(x, fn {_, index} -> has_adjancent?(matrix, length, index) end) end)
      |> Enum.map(fn x -> Enum.reduce(x, 0, fn {value, _}, acc -> (acc * 10) + value end) end)
      |> Enum.sum()
  end

  def part2(args) do
    lines = String.split(args, "\n")
    length = lines
      |> List.first
      |> String.length

    matrix = lines
      |> Enum.flat_map(&String.graphemes/1)
      |> Enum.map(fn x ->
        case Integer.parse(x) do
          {num, ""} -> num
          _ -> x
        end
      end)

    possible_targets = Enum.with_index(matrix)
      |> Enum.chunk_by(fn {value, _} -> is_integer(value) end)
      |> Enum.map(fn x -> Enum.filter(x, fn {value, _} -> is_integer(value) or value == "*" end) end)
      |> Enum.filter(fn x -> length(x) > 0 end)

    number_targets = possible_targets
      |> Enum.filter(fn x -> Enum.any?(x, fn {value, _} -> is_integer(value) end) end)

    possible_targets
      |> List.flatten
      |> Enum.filter(fn {value, _} -> value == "*" end)
      |> Enum.map(fn {_, index} ->
        calculated_adjancents = adjancents(matrix, length, index, &is_integer/1)
        Enum.filter(number_targets, fn x ->
          Enum.any?(x, fn {_, number_index} ->
            Enum.member?(calculated_adjancents, number_index)
          end)
        end)
      end)
      |> Enum.filter(fn matches -> length(matches) == 2 end)
      |> Enum.map(fn matches -> Enum.map(matches, fn x -> Enum.reduce(x, 0, fn {value, _}, acc -> (acc * 10) + value end) end) end)
      |> Enum.map(fn x -> List.first(x) * List.last(x) end)
      |> Enum.sum()
  end

  defp has_adjancent?(matrix, length, index), do: length(adjancents(matrix, length, index, & not is_integer(&1))) > 0

  defp adjancents(matrix, length, index, match_fn) do
    left_edge = rem(index - 1, length) == 0
    right_edge = rem(index + 1, length) == 0

    [
      index - length,
      (if right_edge, do: -1, else: index - length + 1),
      (if right_edge, do: -1, else: index + 1),
      (if right_edge, do: -1, else: index + length + 1),
      index + length,
      (if left_edge, do: -1, else: index + length - 1),
      (if left_edge, do: -1, else: index - 1),
      (if left_edge, do: -1, else: index - length - 1)
    ]
    |> Enum.filter(fn i -> i > 0 end)
    |> Enum.filter(fn i ->
      x = Enum.at(matrix, i)
      x != nil and x != "." and match_fn.(x)
    end)
  end
end
