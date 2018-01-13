IO.puts "Day 22: Sporifica Virus"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_22.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

defmodule Day22 do
  def turn1({x, y} = _direction, state) do
    case state do
      :infected -> {-y, x}
      :clean    -> {y, -x}
    end
  end

  def turn2({x, y} = _direction, state) do
    case state do
      :infected -> {-y,  x}
      :clean    -> { y, -x}
      :flagged  -> {-x, -y}
      _         -> { x,  y}
    end
  end

  def interact1(map, position) do
    case Map.get(map, position, :clean) do
      :clean    -> { Map.put(map, position, :infected), 1 }
      :infected -> { Map.put(map, position, :clean),    0 }
    end
  end

  def interact2(map, position) do
    case Map.get(map, position, :clean) do
      :clean    -> { Map.put(map, position, :weakened), 0 }
      :weakened -> { Map.put(map, position, :infected), 1 }
      :infected -> { Map.put(map, position, :flagged),  0 }
      :flagged  -> { Map.put(map, position, :clean),    0 }
    end
  end

  @compile{:inline, move: 2}
  def move({x, y} = _position, {dx, dy} = _direction), do: { x+dx, y+dy }

  def render(map) do
    {{minx, miny}, {maxx, maxy}} = map |> Map.keys |> Enum.min_max_by(fn {x, y} -> x+y end)
    (for y<-miny..maxx, x<-minx..maxy, do: {x, y})
      |> Enum.chunk_by(fn {_, y} -> y end)
      |> Enum.map(fn chunk -> chunk
        |> Enum.map(fn p -> case Map.get(map, p, :clean) do :clean -> "."; :infected -> "#" end end)
        |> Enum.join end)
      |> Enum.join("\n")
  end

  def burst(map, position, turn_fun \\ &turn1/2, interact_fun \\ &interact1/2, counter \\ 10_000, direction \\ {0,-1}, outbreaks \\ 0)

  def burst(_, _, _, _, 0, _, outbreaks), do: outbreaks

  def burst(map, position, turn_fun, interact_fun, counter, direction,  outbreaks) do
    new_direction = turn_fun.(direction, Map.get(map, position, :clean))
    {new_map, outbreak} = interact_fun.(map, position)
    new_position = move(position, new_direction)
    burst(new_map, new_position, turn_fun, interact_fun, counter-1, new_direction, outbreaks+outbreak)
  end
end

map = input
  |> String.trim
  |> String.split("\n")
  |> Enum.with_index
  |> Enum.flat_map(fn {line, y} ->
      line
        |> String.graphemes
        |> Enum.with_index
        |> Enum.map(fn {"#", x} -> {{x,y}, :infected}; {".", x} -> {{x,y}, :clean} end)
  end)
  |> Map.new

start = map
  |> Map.keys
  |> Enum.max_by(fn {x, y} -> x+y end)
  |> Tuple.to_list
  |> Enum.map(&(div(&1,2)))
  |> List.to_tuple

map
  |> Day22.burst(start)
  |> (&"Part 1: There are #{&1} bursts that cause a node to become infected.").()
  |> IO.puts

map
  |> Day22.burst(start, &Day22.turn2/2, &Day22.interact2/2, 10_000_000)
  |> (&"Part 2: There are #{&1} bursts that cause a node to become infected.").()
  |> IO.puts
