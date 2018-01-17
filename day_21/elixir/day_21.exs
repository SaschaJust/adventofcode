use Bitwise

IO.puts "Day 21: Fractal Art"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_21.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

defmodule Day21 do
  def pattern_to_int(string) do
    string
      |> String.graphemes
      |> Enum.reduce(<<>>, fn char, acc ->
        case char do
          "#" -> << acc::bitstring, <<1::1>>::bitstring >>
          "." -> << acc::bitstring, <<0::1>>::bitstring >>
          _   -> acc
        end
      end)
  end

  defp square_size(bitstring) when is_bitstring(bitstring), do: bitstring |> bit_size |> :math.sqrt |> round

  defp square_size(list) when is_list(list), do: list |> length |> :math.sqrt |> round

  def get_block(image, {x, y}, block_size) do
    size = image |> square_size
    (for offset <- 0..block_size-1, do: x*block_size+y*size*block_size+offset*size)
      |> Enum.reduce(<<>>, fn offset, acc ->
        <<_head::size(offset),block::size(block_size),_tail::bitstring>> = image
        << <<acc::bitstring>>, <<block::size(block_size)>> >>
      end)
  end

  def combine([block]) do
    block
  end

  def combine(blocks) when is_list(blocks) do
    size = blocks |> square_size
    block_size = blocks |> List.first |> square_size
    (for chunk_index <- 0..size-1, y <- 0..block_size-1, do: {chunk_index * size, y})
      |> Enum.map(fn {chunk_index, y} ->
          (for block_index <- 0..size-1  do
              offset = y*block_size
              << _head::size(offset), data::size(block_size), _tail::bitstring >> = blocks |> Enum.at(chunk_index + block_index)
              <<data::size(block_size)>>
            end)
          |> Enum.reduce(<<>>, fn bs, acc -> << <<acc::bitstring>>, <<bs::bitstring>> >> end)
    end)
    |> Enum.reduce(<<>>, fn bs, acc -> << <<acc::bitstring>>, <<bs::bitstring>> >> end)
  end

  def rotate(bitstring) do
    size = bitstring |> square_size
    (for y <-size-1..0, x <- 0..size-1, do: y+x*size)
      |> Enum.reduce(<<>>, fn offset, acc ->
        <<_head::size(offset),block::1,_tail::bitstring>> = bitstring
        << <<acc::bitstring>>, <<block::1>> >>
      end)
  end

  def flip(bitstring) do
    size = bitstring |> square_size
    (for y <-0..size-1, x <-size-1..0, do: x+y*size)
      |> Enum.reduce(<<>>, fn offset, acc ->
        <<_head::size(offset),block::1,_tail::bitstring>> = bitstring
        << <<acc::bitstring>>, <<block::1>> >>
      end)
  end

  def print(bitstring) when is_bitstring(bitstring) do
    size = bitstring |> square_size
    (for << bit::1 <- bitstring >>, do: (case bit do 1 -> "#"; 0 -> "." end))
      |> Enum.chunk_every(size)
      |> Enum.map(fn chunk -> chunk |> Enum.join end)
      |> Enum.join("\n")
  end

  def print(rulebook) when is_map(rulebook) do
    rulebook
      |> Map.keys
      |> Enum.map(fn key -> "#{key |> Day21.print} => #{Map.get(rulebook, key) |> Day21.print}" end)
      |> Enum.sort
      |> Enum.join("\n")
  end

  def enhance(image, rulebook, iterations \\ 5)

  def enhance(image, _, 0) do
    (for << bit::1 <- image >>, do: bit) |> Enum.sum
  end

  def enhance(image, rulebook, iterations) do
    size = image |> square_size
    block_size = cond do
      rem(size, 2) == 0 -> 2
      true -> 3
    end

    new_image = (for y <- 0..div(size, block_size)-1, x <- 0..div(size, block_size)-1, do: {x, y})
      |> Enum.map(fn coord -> image |> get_block(coord, block_size) |> (&Map.get(rulebook, &1, {nil, &1 |> print})).() end)

    # This exploits the repetitive nature. Once we find a 9x9 grid, the 3x3 blocks develop independently.
    if size == 9 do
      new_image
        |> Enum.group_by(&(&1))
        |> Map.to_list
        |> Enum.reduce(0, fn {value,list}, acc -> acc + length(list) * enhance(value, rulebook, iterations-1) end)
    else
      enhance(new_image |> combine, rulebook, iterations-1)
    end
  end

end

image = ".#...####" |> Day21.pattern_to_int

rulebook = input
  |> String.trim
  |> String.split("\n")
  |> Enum.map(fn line -> line
    |> String.split(" => ")
    |> Enum.map(&Day21.pattern_to_int/1)
    |> List.to_tuple
  end)
  |> Enum.flat_map(fn {x, y} -> # expand rotations and flips
    r1 = x  |> Day21.rotate
    r2 = r1 |> Day21.rotate
    r3 = r2 |> Day21.rotate
    [
      {x,  y},
      {x  |> Day21.flip, y},
      {r1, y},
      {r1 |> Day21.flip, y},
      {r2, y},
      {r2 |> Day21.flip, y},
      {r3, y},
      {r3 |> Day21.flip, y},
    ]
  end)
  |> Map.new

# rulebook |> Day21.print |> IO.puts

Day21.enhance(image, rulebook)
  |> (&"Part 1: There are #{&1} active pixels after 5 iterations.").()
  |> IO.puts

Day21.enhance(image, rulebook, 18)
  |> (&"Part 2: There are #{&1} active pixels after 18 iterations.").()
  |> IO.puts
