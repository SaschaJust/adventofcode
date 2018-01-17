IO.puts "Day 05: A Maze of Twisty Trampolines, All Alike"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_05.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

map = input
  |> String.trim
  |> String.split("\n")
  |> Enum.with_index
  |> Enum.map(fn {x, y} -> {y, String.to_integer x} end)
  |> Map.new

defmodule Day05 do
  def jump1(map, index, step) do
    cond do
      map_size(map) <= index -> step
      true -> jump1(Map.put(map, index, Map.get(map, index) + 1), index + Map.get(map, index), step + 1)
    end
  end

  def jump2(map, index, step) do
    cond do
      map_size(map) <= index -> step
      true -> jump2(Map.put(map, index, Map.get(map, index) + (if Map.get(map, index) >= 3, do: -1, else: 1)), index + Map.get(map, index), step + 1)
    end
  end
end

map
  |> Day05.jump1(0, 0)
  |> (&"Part 1: It takes #{&1} steps to reach the exit.").()
  |> IO.puts
# result: 374269

map
  |> Day05.jump2(0, 0)
  |> (&"Part 2: It takes #{&1} steps to reach the exit.").()
  |> IO.puts
# result: 27720699
