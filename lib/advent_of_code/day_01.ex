defmodule AdventOfCode.Day01 do
  @spec part1(any()) :: nil
  def part1(args) do
    args
    |> String.split("\n")
    |> Enum.map(fn line ->
      numbers =
        String.graphemes(line)
        |> Enum.map(fn c ->
          case Integer.parse(c) do
            {num, ""} -> num
            _ -> -1
          end
        end)
        |> Enum.filter(fn i -> i > 0 end)

      if length(numbers) > 0 do
        res = 10 * List.first(numbers) + List.last(numbers)
        IO.puts("#{Kernel.inspect(numbers, charlists: :as_lists)}: #{res}")
        res
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
      |> String.replace("one", "o1e")
      |> String.replace("two", "t2o")
      |> String.replace("three", "t3e")
      |> String.replace("four", "f4r")
      |> String.replace("five", "f5e")
      |> String.replace("six", "s6x")
      |> String.replace("seven", "s7n")
      |> String.replace("eight", "e8t")
      |> String.replace("nine", "n9n")
      |> part1
  end
end
