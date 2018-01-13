IO.puts "Day 24: Electromagnetic Moat"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_24.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

defmodule Day24 do

  def part1_reducer(list) do
    list |> Enum.reduce({0,[]}, fn p={a,_}, {acca, _}=acc -> if a>acca, do: p, else: acc end)
  end

  def part2_reducer(list) do
    list |> Enum.reduce({0,0}, fn p={a,b}, {acca, accb}=acc -> if b>accb or b==accb and a>acca, do: p, else: acc end)
  end

  def perform(blocks, reducer, endpoint \\ 0) do
    {applicable, remainder} = blocks |> Enum.split_with(fn {a,b} -> a == endpoint or b == endpoint end)

    case applicable do
      [] -> {0, 0}
      _ -> applicable
            |> Enum.map(fn {a,b}=x -> {value, trace} = perform((List.delete(applicable, x) ++ remainder), reducer, (if a == endpoint, do: b, else: a))
             {value+a+b, trace+1} end)
            |> reducer.()
    end
  end
end

blocks = input
  |> String.trim
  |> String.split("\n")
  |> Enum.map(fn x -> x |> String.split("/") |> Enum.map(&String.to_integer/1) |> List.to_tuple end)

blocks
  |> Day24.perform(&Day24.part1_reducer/1)
  |> (&"The strength of the strongest bridge is #{&1 |> elem(0)}.").()
  |> IO.puts

blocks
  |> Day24.perform(&Day24.part2_reducer/1)
  |> (&"The strength of the longest bridge is #{&1 |> elem(0)}.").()
  |> IO.puts
