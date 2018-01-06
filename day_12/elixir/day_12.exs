{:ok, input} = File.read("../day_12.input")

defmodule Day12 do
  def connected(map, set, key) do
    if set |> MapSet.member?(key) do
      set
    else
      map |> Map.get(key) |> Enum.reduce(MapSet.new, fn (x, acc) -> acc |> MapSet.union(map |> connected(set |> MapSet.put(key), x)) end)
    end
  end

  def group(%{}, count) do
    count
  end

  def group(%{})
end

map =
input
  |> String.trim
  |> String.split("\n")
  |> Enum.map(fn x -> String.split(x, " <-> ") end)
  |> Enum.reduce(Map.new, fn ([x,y], acc) -> acc |> Map.put(x |> String.to_integer, y |> String.split(", ") |> Enum.map(&String.to_integer/1)) end)

group = map |> Day12.connected(MapSet.new, 0)
group |> MapSet.size |> IO.inspect

group
  |> MapSet.to_list
  |> Enum.reduce(map, fn (x, acc) -> acc |> Map.pop(x) end)
