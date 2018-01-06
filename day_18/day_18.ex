{:ok, input} = File.read("star_18.input")

defmodule Day18 do
  def value(registers, token) do
    case Integer.parse(token) do
      :error -> registers |> Map.get(token)
      {value, ""} -> value
    end
  end

  def process(["set", reg, val], registers, pc, _) do
    {registers |> Map.put(reg, value(registers, val)), pc+1}
  end

  def process(["add", reg, val], registers, pc, _) do
    {registers |> Map.put(reg, Map.get(registers, reg, 0) + value(registers, val)), pc+1}
  end

  def process(["mul", reg, val], registers, pc, _) do
    {registers |> Map.put(reg, Map.get(registers, reg, 0) * value(registers, val)), pc+1}
  end

  def process(["mod", reg, val], registers, pc, _) do
    {registers |> Map.put(reg, rem(Map.get(registers, reg, 0), value(registers, val))), pc+1}
  end

  def process(["jgz", switch, val], registers, pc, _) do
    {registers, (if value(registers, switch) > 0, do: pc + value(registers, val), else: pc+1)}
  end

  def process(["snd", val], registers, pc, pid) do
    send pid, {:msg, value(registers, val)}
    cond do
      # part 1
      self() == pid -> {Map.put(registers, "snd", value(registers, val)), pc+1}
      # part 2
      true -> {Map.put(registers, "snd", Map.get(registers, "snd", 0)+1), pc+1}
    end
  end

  def process(["rcv", val], registers, pc, pid) do
    receive do
      {:msg,value} -> cond do
        # part 1
        self() == pid and value(registers, val) != 0 -> {registers, -1}
        # part 2
        true -> {Map.put(registers, val, value), pc+1}
      end
    after 1_000 -> {registers, -1}
    end
  end

  def execute({registers, pc}, program, pid) when is_map(registers) do
    cond do
      Map.size(program) > pc and pc >= 0 -> (process(Map.get(program, pc), registers, pc, pid) |> execute(program, pid))
      true -> {registers, pc}
    end
  end

  def execute(program, id) do
    receive do
      {:task,%{:owner=> _, :pid=> pid, :ref=> _}} -> execute({%{"p" => id}, 0}, program, pid)
                      |> Tuple.to_list
                      |> Enum.at(0)
                      |> Map.get("snd")
                      |> (&"Program #{id} result value #{&1}.").()
                      |> IO.puts
      {_, message} -> raise "Invalid message received: #{message}"
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

IO.puts "Part 1:"
task0 = Task.async fn->Day18.execute(program, 0) end
send Map.fetch!(task0, :pid), {:task, task0}
Task.await(task0)

IO.puts "Part 2:"
task0 = Task.async fn->Day18.execute(program, 0) end
task1 = Task.async fn->Day18.execute(program, 1) end

send Map.fetch!(task0, :pid), {:task, task1}
send Map.fetch!(task1, :pid), {:task, task0}

Task.await(task0)
Task.await(task1)
