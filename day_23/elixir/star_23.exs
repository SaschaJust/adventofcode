{:ok, input} = File.read("star_22.input")

defmodule Day22 do
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
    if reg == "h", do: registers |> IO.inspect
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
end

program = input
  |> String.trim
  |> String.split("\n")
  |> Enum.map(&String.split/1)
  |> Enum.with_index
  |> Enum.map(fn({x, y}) -> {y, x} end)
  |> Map.new

Day22.execute({%{"c" => 1}, 0}, program) |> IO.puts
