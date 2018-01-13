use Bitwise

IO.puts "Day 15: Dueling Generators"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_15.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

gen_inputs = input
  |> String.trim
  |> String.split("\n")
  |> Enum.map(fn x -> x |> String.split(" ") |> List.last |> String.to_integer end)
  |> List.to_tuple

defmodule Day15 do
  @seed_a 16_807
  @seed_b 48_271
  @rem 2_147_483_647

  def generate(_, _, 0, _) do
    []
  end

  def generate(prev, seed, count, mod) do
    p=rem(prev*seed,@rem)
    case rem(p,mod) do
      0 -> [ p | generate(p, seed, count-1, mod) ]
      _ -> generate(p, seed, count, mod)
    end
  end

  def agreements({input_a, input_b}, iterations, mod_a \\ 1, mod_b \\ 1) do
    Enum.zip(input_a |> generate(@seed_a, iterations, mod_a), input_b |> generate(@seed_b, iterations, mod_b))
      |> Enum.count(fn {a,b} -> (a&&&0xFFFF) == (b&&&0xFFFF) end)
  end
end

Day15.agreements(gen_inputs, 40_000_000)
  |> (&"There are #{&1} agreements.").()
  |> IO.puts

Day15.agreements(gen_inputs, 5_000_000, 4, 8)
  |> (&"There are #{&1} agreements.").()
  |> IO.puts
