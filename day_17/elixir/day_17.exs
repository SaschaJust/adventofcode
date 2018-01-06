input = 382

defmodule Day17 do
  def insert(buffer,_,_,_,0) do
    buffer
  end

  def insert(buffer, index, current, step_size, counter) do
    new_index = rem(index + step_size, current) + 1
    insert(buffer |> List.insert_at(new_index, current), new_index, current+1, step_size, counter-1)
  end

  def short_circuit(_, _, _, 0, result) do
    result
  end

  def short_circuit(index, current, step_size, counter, result) do
    new_index = rem(index + step_size, current) + 1
    short_circuit(new_index, current+1, step_size, counter-1, (if new_index==1, do: current, else: result))
  end
end

Day17.insert([0], 0, 1, input, 2017)
  |> Enum.chunk_by((&Kernel.==(&1,2017)))
  |> Enum.reverse
  |> Enum.at(0)
  |> Enum.at(0)
  |> (&"The value after 2017 is: #{&1}").()
  |> IO.puts

Day17.short_circuit(0, 1, input, 50000000, 0)
  |> (&"The value after 0 is: #{&1}").()
  |> IO.puts
