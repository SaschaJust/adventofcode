{_, input} = File.read("star_09.input")

string = input \
  |> String.trim

defmodule Star09 do
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
    IO.puts "Garbage count: #{garbage_count}"
    0
  end
end

string |> Star09.parse(0, false, 0) |> IO.puts
