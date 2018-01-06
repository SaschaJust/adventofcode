{:ok, input} = File.read("../day_16.input")

defmodule Day16 do
  def swap(state, first, second) do
    state |> List.replace_at(first, state |> Enum.at(second)) |> List.replace_at(second, state |> Enum.at(first))
  end

  def dance("s" <> x, state) do
    {lhs, rhs} = state |> Enum.split((state |> Enum.count) - String.to_integer(x) )
    rhs ++ lhs
  end

  def dance("x" <> <<a::size(8)>> <> "/" <> b, state) do
    state |> swap(<<a>> |> String.to_integer, b |> String.to_integer)
  end

  def dance("x" <> <<a::size(16)>> <> "/" <> b, state) do
    state |> swap(<<a::size(16)>> |> String.to_integer, b |> String.to_integer)
  end

  def dance("p" <> <<a::size(8)>> <> "/" <> b, state) do
    state |> swap(state |> Enum.find_index(&Kernel.==(&1,<<a>>)), state |> Enum.find_index(&Kernel.==(&1,b)))
  end

  def round(instructions, state) do
      instructions |> Enum.reduce(state, fn(x, acc) -> x |> Day16.dance(acc) end)
  end

  def perform(instructions, state, counter \\ 1)

  def perform(_, state, 0) do
      state
  end

  def perform(instructions, state, counter) do
    perform(instructions, instructions |> round(state), counter-1)
  end

  def cycle_length(instructions, initial, state, counter) do
    new_state = instructions |> round(state)
    cond do
      new_state == initial -> counter
      true -> cycle_length(instructions, initial, new_state, counter + 1)
    end
  end
end

initial = for(i<-0..15, do: <<?a+i>>)

cycle_length =
input
  |> String.trim
  |> String.split(",")
  |> Day16.cycle_length(initial, initial, 1)

cycle_length |> IO.puts

input
  |> String.trim
  |> String.split(",")
  |> Day16.perform(initial, cycle_length)
  |> Enum.join
  |> (&"Program order: #{&1}").()
  |> IO.puts

input
  |> String.trim
  |> String.split(",")
  |> Day16.perform(initial, rem(1000000000, cycle_length))
  |> Enum.join
  |> (&"Program order: #{&1}").()
  |> IO.puts
