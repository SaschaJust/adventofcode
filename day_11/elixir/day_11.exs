IO.puts "Day 11: Hex Ed"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_11.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

defmodule Day11 do
  def step(list, coordinates \\ {0, 0, 0}, max_distance \\ 0)

  def step([ "ne" | remainder ], {x, y, z}, max_distance) do
    step(remainder, {x+1, y-1, z}, max(max_distance, {x, y, z} |> distance))
  end

  def step([ "n" | remainder ], {x, y, z}, max_distance) do
    step(remainder, {x+1, y, z-1}, max(max_distance, {x, y, z} |> distance))
  end

  def step([ "nw" | remainder ], {x, y, z}, max_distance) do
    step(remainder, {x, y+1, z-1}, max(max_distance, {x, y, z} |> distance))
  end

  def step([ "se" | remainder ], {x, y, z}, max_distance) do
    step(remainder, {x, y-1, z+1}, max(max_distance, {x, y, z} |> distance))
  end

  def step([ "s" | remainder ], {x, y, z}, max_distance) do
    step(remainder, {x-1, y, z+1}, max(max_distance, {x, y, z} |> distance))
  end

  def step([ "sw" | remainder ], {x, y, z}, max_distance) do
    step(remainder, {x-1, y+1, z}, max(max_distance, {x, y, z} |> distance))
  end

  def step([], {x, y, z}, max_distance) do
    {{x, y, z} |> distance, max(max_distance, {x, y, z} |> distance)}
  end

  def distance({x, y, z}) do
    max(abs(x), max(abs(y),abs(z)))
  end
end

result = input
  |> String.trim
  |> String.split(",")
  |> Day11.step

result |> (&"Part 1: Fewest number of steps required are #{&1 |> elem(0)}.").() |> IO.puts
result |> (&"Part 2: The furthest he got away from origin is #{&1 |> elem(1)} steps.").() |> IO.puts
# result: {707, 1490}
