IO.puts "Day 12: Digital Plumber"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_12.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

defmodule Day12 do
  def connected(map, set, key) do
    cond do
      set |> MapSet.member?(key) -> set
      true -> map |> Map.get(key) |> Enum.reduce(MapSet.new, fn x, acc -> acc |> MapSet.union(map |> connected(set |> MapSet.put(key), x)) end)
    end
  end

  def groups(map, group_count \\ 0)

  def groups(map, group_count) when map_size(map) == 0 do
    group_count
  end

  def groups(map, group_count) do
    start = map |> Map.keys |> List.first
    groups(map |> connected(MapSet.new, start) |> Enum.reduce(map, fn x, acc -> Map.delete(acc, x) end), group_count+1)
  end
end

map = input
  |> String.trim
  |> String.split("\n")
  |> Enum.map(fn x -> String.split(x, " <-> ") end)
  |> Enum.reduce(Map.new, fn [x,y], acc -> acc |> Map.put(x |> String.to_integer, y |> String.split(", ") |> Enum.map(&String.to_integer/1)) end)

group = map |> Day12.connected(MapSet.new, 0)
group |> MapSet.size |> (&"Part 1: There are #{&1} programs in the group thats contains program ID 0.").() |> IO.puts

map |> Day12.groups |> (&"Part 2: There are #{&1} groups in total.").() |> IO.puts

# group
#   |> MapSet.to_list
#   |> Enum.reduce(map, fn (x, acc) -> acc |> Map.pop(x) end)
