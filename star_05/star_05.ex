{_, input} = File.read("star_05.input")
map = input \
  |> String.trim \
  |> String.split("\n") \
  |> Enum.with_index \
  |> Enum.map(fn {x, y} -> {y,String.to_integer x} end) \
  |> Map.new

defmodule Star05 do
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

map |> Star05.jump1(0, 0) |> IO.puts
# result: 374269
map |> Star05.jump2(0, 0) |> IO.puts
# result: 27720699
