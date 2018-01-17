IO.puts "Day 20: Particle Swarm"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_20.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

defmodule Day20 do
  @give_up 100

  def manhattan({x, y, z}) do
    abs(x) + abs(y) + abs(z)
  end

  def simulate(list, @give_up) do
    list
  end

  def simulate(list, index) do
      simulate(list |> Enum.map(fn {{{p1,p2,p3}, {v1,v2,v3}, {a1,a2,a3}=a}, id} -> {{{p1+v1+a1, p2+v2+a2, p3+v3+a3}, {v1+a1, v2+a2, v3+a3}, a}, id} end)
                    |> Enum.group_by(fn {{p, _, _}, _} -> p end)
                    |> Map.values
                    |> Enum.filter(fn x -> x |> Enum.count == 1 end)
                    |> List.flatten, index+1)
  end
end

particles = input
  |> String.trim
  |> String.split("\n")
  |> Enum.map(fn x -> Regex.scan(~r/-?\d+/, x)
                      |> List.flatten
                      |> Enum.map(&String.to_integer/1)
                      |> Enum.chunk_every(3)
                      |> Enum.map(&List.to_tuple/1)
                      |> List.to_tuple
              end)
  |> Enum.with_index

particles
  |> Enum.group_by(fn {{_, _, a}, _} -> a |> Day20.manhattan end)
  |> Map.to_list
  |> Enum.min_by(fn {key, _} -> key end)
  |> elem(1)
  |> Enum.min_by(fn {{_, v, _}, _} -> v |> Day20.manhattan end)
  |> elem(1)
  |> (&"Part 1: Particle number #{&1} will stay closed to (0, 0, 0) in the long run.").()
  |> IO.puts

particles
  |> Day20.simulate(0)
  |> Enum.count
  |> (&"Part 2: There are #{&1} particles left.").()
  |> IO.puts
