IO.puts "Day 23: Coprocessor Conflagration"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_23.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

defmodule Day23 do
  def value(registers, token) do
    case Integer.parse(token) do
      :error -> registers |> Map.get(token, 0)
      {value, ""} -> value
    end
  end

  def process(["set", reg, val], registers, pc) do
    {registers |> Map.put(reg, value(registers, val)), pc+1}
  end

  def process(["mul", reg, val], registers, pc) do
    registers = registers |> Map.put(:muls, (registers |> Map.get(:muls, 0)) + 1)
    {registers |> Map.put(reg, Map.get(registers, reg, 0) * value(registers, val)), pc+1}
  end

  def process(["sub", reg, val], registers, pc) do
    {registers |> Map.put(reg, Map.get(registers, reg, 0) - value(registers, val)), pc+1}
  end

  def process(["jnz", switch, val], registers, pc) do
      {registers, (if value(registers, switch) != 0, do: pc + value(registers, val), else: pc+1)}
    end

  def execute({registers, pc}, program) do
    cond do
      Map.size(program) > pc and pc >= 0 -> process(Map.get(program, pc), registers, pc) |> execute(program)
      true -> registers |> Map.get(:muls)
    end
  end

  def is_prime?(2), do: true

  def is_prime?(x) when x>1 do
    (2..round(Float.ceil(:math.sqrt(x)))
      |> Enum.filter(fn a -> rem(x, a) == 0 end))
      |> length() == 0
  end

  def count_none_prime(from, to, interval \\ 1) do
    Stream.iterate(from, &(&1+interval))
      |> Enum.take(div(to-from,interval)+1)
      |> Stream.filter(&Kernel.not(is_prime?(&1)))
      |> Enum.to_list
  end
end

program = input
  |> String.trim
  |> String.split("\n")
  |> Enum.map(&String.split/1)
  |> Enum.with_index
  |> Enum.map(fn({x, y}) -> {y, x} end)
  |> Map.new

Day23.execute({%{}, 0}, program)
  |> (&"Part 1: The instruction 'mul' is called #{&1} times.").()
  |> IO.puts

# Part 2 counts the number of none-prime between b and c in steps of size 17.
# That's the resulting value in h.
Day23.count_none_prime(108100, 125100, 17)
  |> Enum.count
  |> (&"Part 2: The final value of h (the number of none-prime number between b=108100 and c=125100 in steps of size 17) is #{&1}.").()
  |> IO.puts
