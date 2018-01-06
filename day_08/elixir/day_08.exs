{:ok, input} = File.read("../day_08.input")

map_list = input
  |> String.trim
  |> String.split("\n")
  |> Enum.map(fn x -> ~r/(?<name>\S+) (?<instruction>inc|dec) (?<delta>-?\d+) if (?<lhs>\w+) (?<op>>|<|>=|<=|!=|==) (?<rhs>-?\d+)/
    |> Regex.named_captures(x) end)

defmodule Day08 do
  def fun(operator) do
    case operator do
      "<=" -> &<=/2
      "<" -> &</2
      ">=" -> &>=/2
      ">" -> &>/2
      "==" -> &==/2
      "!=" -> &!=/2
      "inc" -> &(&1+&2)
      "dec" -> &(&1-&2)
    end
  end

  def process([ %{"name" => name, "instruction" => instruction, "delta" => delta, "lhs" => lhs, "op" => op, "rhs" => rhs} | remainder ], registers, max) do
    if Day08.fun(op).(
      Map.get(registers, lhs, 0),
      String.to_integer(rhs)
    ) do
      new_value = Day08.fun(instruction).(
        Map.get(registers, name, 0),
        String.to_integer(delta)
      );
      process(remainder, Map.put(registers, name, new_value), max(max, new_value))
    else
      process(remainder, registers, max)
    end
  end

  def process([], registers, max) do
    {registers |> Map.values |> Enum.max, max}
  end
end

map_list |> Day08.process(Map.new(), 0) |> IO.inspect
