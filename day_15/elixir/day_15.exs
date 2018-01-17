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

  def agreements({input_a, input_b}, iterations, mod_a \\ 1, mod_b \\ 1) do
    generator_a = Stream.unfold(rem(input_a*@seed_a,@rem), fn n -> {n&&&0xFFFF,rem(n*@seed_a,@rem)} end)
    |> Stream.filter(fn x -> rem(x, mod_a) == 0 end)

    generator_b = Stream.unfold(rem(input_b*@seed_b,@rem), fn n -> {n&&&0xFFFF,rem(n*@seed_b,@rem)} end)
    |> Stream.filter(fn x -> rem(x, mod_b) == 0 end)

    Stream.zip(generator_a, generator_b)
    |> Stream.take(iterations)
    |> Stream.filter(fn {a, b} -> a == b end)
    |> Enum.count
  end
end

Day15.agreements(gen_inputs, 40_000_000)
  |> (&"Part 1: There are #{&1} agreements.").()
  |> IO.puts

Day15.agreements(gen_inputs, 5_000_000, 4, 8)
  |> (&"Part 2: There are #{&1} agreements.").()
  |> IO.puts
