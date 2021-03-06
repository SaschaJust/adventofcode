IO.puts "Day 07: Recursive Circus"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_07.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

map_list = input
  |> String.trim
  |> String.split("\n")
  |> Enum.map(fn x -> ~r/(?<name>\S+) \((?<weight>\d+)\)( -> (?<children>.*))?/
    |> Regex.named_captures(x) end)

defmodule Day07 do

  def find_root([ %{"name" => _, "weight" => _, "children" => ""} | remainder ], lhs, rhs) do
    find_root(remainder, lhs, rhs)
  end

  def find_root([ %{"name" => name, "weight" => _, "children" => children} | remainder ], lhs, rhs) do
    find_root(
      remainder,
      MapSet.put(lhs, name),
      (children |> String.split(", ") |> Enum.reduce(rhs, fn x, res -> MapSet.put(res, x) end))
    )
  end

  def find_root([], lhs, rhs) do
    MapSet.difference(lhs, rhs)
    |> MapSet.to_list
    |> Enum.fetch!(0)
  end

  def build_tree([], map) do
    map
  end

  def build_tree([ %{"name" => name, "weight" => weight, "children" => children} | remainder ], map) do
    build_tree(remainder, Map.put(map, name, {String.to_integer(weight), children |> String.split(", ")}) )
  end

  def compute_weight(root, map) do
    case Map.get(map, root) do
      {weight, [""]} -> weight
      {weight, list} -> weight + Enum.reduce(list, 0, fn x, acc -> acc + compute_weight(x, map) end)
    end
  end

  def find_imbalance(root, tree, imbalance) do
    {weight, list} = Map.get(tree, root)

    subgroups = list |> Enum.map(fn x -> {x, Day07.compute_weight(x, tree)} end)
      |> Enum.group_by(fn {_, weight} -> weight end)
      |> Map.to_list

    case subgroups |> Enum.find(fn {_, y} -> y |> Enum.count == 1 end)  do
      nil -> weight + imbalance
      {_, [{name, off1} | _]} -> {_, [{_, off2} | _]} = subgroups
        |> Enum.find(fn {_, y} -> y |> Enum.count != 1 end); find_imbalance(name, tree, off2 - off1)
    end
  end
end

root = map_list |> Day07.find_root(MapSet.new(), MapSet.new())
root
  |> (&"Part 1: The name of the bottom program is '#{&1}'.").()
  |> IO.puts

tree = map_list |> Day07.build_tree(Map.new())
root
  |> Day07.find_imbalance(tree, 0)
  |> (&"Part 2: The weight of the one program with wrong weight needs to be #{&1}.").()
  |> IO.puts
