IO.puts "Day 04: High-Entropy Passphrases"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_04.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

input
  |> String.trim
  |> String.split("\n")
  |> Enum.filter(fn x ->
    (x
      |> String.split(" ")
      |> (&Enum.count(&1) == (&1 |> Enum.uniq |> Enum.count)).()
    ) end)
  |> Enum.count
  |> (&"Part 1: There are #{&1} valid phrases.").()
  |> IO.puts
# result: 383

input
  |> String.trim
  |> String.split("\n")
  |> Enum.filter(fn(x) ->
    (x
      |> String.split(" ")
      |> Enum.map(fn x -> x |> String.graphemes |> Enum.sort end)
      |> (&Enum.count(&1) == (&1 |> Enum.uniq |> Enum.count)).()
    ) end)
  |> Enum.count
  |> (&"Part 2: There are #{&1} valid phrases under the new system policy.").()
  |> IO.puts
# result 265
