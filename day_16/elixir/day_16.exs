IO.puts "Day 16: Permutation Promenade"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_16.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

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

cycle_length = input
  |> String.trim
  |> String.split(",")
  |> Day16.cycle_length(initial, initial, 1)

input
  |> String.trim
  |> String.split(",")
  |> Day16.perform(initial, 1)
  |> Enum.join
  |> (&"Part 1: Program order after the dance: #{&1}").()
  |> IO.puts

input
  |> String.trim
  |> String.split(",")
  |> Day16.perform(initial, rem(1_000_000_000, cycle_length))
  |> Enum.join
  |> (&"Part 2: Program order after a billion dances: #{&1}").()
  |> IO.puts
