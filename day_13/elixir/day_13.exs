IO.puts "Day 13: Packet Scanners"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_13.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

defmodule Day13 do
  def severity([{level, depth} | tail], offset) do
    position = case rem(level + offset, 2*(depth-1)) do
      x when x in 0..depth-1 -> rem(x, depth)
      x when true -> depth - 1 - rem(x, depth)
    end

    if position == 0, do: level * depth + severity(tail, offset), else: severity(tail, offset)
  end

  def severity([], _) do
    0
  end

  def check([{level, depth} | tail], offset) do
    position = case rem(level + offset, 2*(depth-1)) do
      x when x in 0..depth-1 -> rem(x, depth)
      x when true -> depth - 1 - rem(x, depth)
    end

    if position == 0, do: false, else: check(tail, offset)
  end

  def check([], _) do
    true
  end

  def find_offset([], _) do
    nil
  end

  def find_offset(list, offset) do
    case check list, offset do
      true -> offset
      _ -> find_offset list, offset+1
    end
  end
end

list = input
  |> String.trim
  |> String.split("\n")
  |> Enum.map(fn x -> String.split(x, ": ")
                      |> Enum.map(&String.to_integer/1)
                      |> List.to_tuple
    end)

list
  |> Day13.severity(0)
  |> (&"Part 1: The severity of the whole trip is #{&1}.").()
  |> IO.puts

list
  |> Day13.find_offset(0)
  |> (&"Part 2: The fewest number of picoseconds need for delay is #{&1}.").()
  |> IO.puts
