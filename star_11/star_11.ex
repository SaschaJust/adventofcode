{:ok, input} = File.read("star_11.input")

defmodule Star11 do
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
    {{x, y, z} |> distance, max_distance}
  end

  def distance({x, y, z}) do
    max(abs(x), max(abs(y),abs(z)))
  end
end

input \
  |> String.trim
  |> String.split(",")
  |> Star11.step({0, 0, 0}, 0)
  |> IO.inspect
# result: {707, 1490}
