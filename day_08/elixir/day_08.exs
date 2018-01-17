IO.puts "Day 08: I Heard You Like Registers"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_08.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

map_list = input
  |> String.trim
  |> String.split("\n")
  |> Enum.map(fn x -> ~r/(?<name>\S+) (?<instruction>inc|dec) (?<delta>-?\d+) if (?<lhs>\w+) (?<op>>|<|>=|<=|!=|==) (?<rhs>-?\d+)/
    |> Regex.named_captures(x) end)

defmodule Day08 do
  def fun(operator) do
    case operator do
      "<="  -> &<=/2
      "<"   -> &</2
      ">="  -> &>=/2
      ">"   -> &>/2
      "=="  -> &==/2
      "!="  -> &!=/2
      "inc" -> &+/2
      "dec" -> &-/2
    end
  end

  def process([ %{"name" => name, "instruction" => instruction, "delta" => delta, "lhs" => lhs, "op" => op, "rhs" => rhs} | remainder ], registers, max) do
    if fun(op).(
      Map.get(registers, lhs, 0),
      String.to_integer(rhs)
    ) do
      new_value = fun(instruction).(
        Map.get(registers, name, 0),
        String.to_integer(delta)
      )
      process(remainder, Map.put(registers, name, new_value), max(max, new_value))
    else
      process(remainder, registers, max)
    end
  end

  def process([], registers, max) do
    {registers |> Map.values |> Enum.max, max}
  end
end

result = map_list |> Day08.process(Map.new, 0)

IO.puts "Part 1: The largest value in any register at the end is #{result |> elem(0)}."
IO.puts "Part 2: The largest value in any register at any given times is #{result |> elem(1)}."
