IO.puts "Day 09: Stream Processing"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_09.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

string = input |> String.trim

defmodule Day09 do
  def parse(string, group_level \\ 0, garbage \\ false, garbage_count \\ 0)

  def parse("{" <> remainder, group_level, false, garbage_count) do
    parse(remainder, group_level+1, false, garbage_count)
  end

  def parse("!" <> <<_::size(8)>> <> remainder, group_level, is_garbage?, garbage_count) do
    parse(remainder, group_level, is_garbage?, garbage_count)
  end

  def parse("<" <> remainder, group_level, false, garbage_count) do
    parse(remainder, group_level, true, garbage_count)
  end

  def parse(">" <> remainder, group_level, true, garbage_count) do
    parse(remainder, group_level, false, garbage_count)
  end

  def parse("}" <> remainder, group_level, false, garbage_count) do
    group_level + parse(remainder, group_level-1, false, garbage_count)
  end

  def parse("," <> remainder, group_level, false, garbage_count) do
    parse(remainder, group_level, false, garbage_count)
  end

  def parse(<<_::size(8)>> <> remainder, group_level, true, garbage_count) do
    parse(remainder, group_level, true, garbage_count + 1)
  end

  def parse("", _, _, garbage_count) do
    IO.puts "Part 2: Garbage count: #{garbage_count}"
    0
  end
end

string
  |> Day09.parse
  |> (&"Part 1: The total score of all groups is #{&1}.").()
  |> IO.puts
