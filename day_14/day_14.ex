use Bitwise
{:ok, input} = File.read("star_14.input")

defmodule Day10 do
  def reverse({rev_rhs, rev_lhs}, {const_lhs, const_rhs}) do
      {new_rhs, new_lhs} = rev_rhs ++ rev_lhs |> Enum.reverse |> Enum.split(Enum.count(rev_rhs))
      new_lhs ++ const_lhs ++ new_rhs ++ const_rhs
  end

  def pinch([ length | remainder ], list, position, skip_size) do
    pinch(
      remainder,
      reverse(
        {
          Enum.slice(list, position, length),
          Enum.slice(list, 0, (if position + length > Enum.count(list), do: rem(position+length, Enum.count(list)), else: 0))
        },
        {
          Enum.slice(list, (if position + length > Enum.count(list), do: rem(position+length, Enum.count(list)), else: 0), position-(if position + length > Enum.count(list), do: rem(position+length, Enum.count(list)), else: 0)),
          Enum.slice(list, position+length, Enum.count(list))
        }
      ),
      rem(position+length+skip_size, Enum.count(list)),
      skip_size+1
    )
  end

  def pinch([], list, _, _) do
    list
  end

  def knot_hash(input) do
    Enum.to_list(1..64)
      |> Enum.reduce([], fn(_, acc) -> acc ++ (input |> String.trim |> to_charlist) ++ [17,31,73,47,23] end)
      |> Day10.pinch(Enum.to_list(0..255), 0, 0)
      |> Enum.chunk_every(16)
      |> Enum.map(fn x -> x |> Enum.reduce(0, &^^^/2) end)
      |> Enum.reduce("", fn(x, acc) -> acc <> Base.encode16(<<x>>) end)
  end
end

defmodule Day14 do
  @xdim 128
  @ydim 128
  @size @xdim*@ydim

  def used_blocks(hashlist) do
    hashlist
      |> Enum.map(fn(x) -> for(<<bit::1 <- x |> Base.decode16!>>, do: bit) |> Enum.sum end)
      |> Enum.sum
  end

  def grid(hashlist) do
    hashlist |> grid(0, <<0::size(@size)>>)
  end

  def grid([], _, bitmap) do
    bitmap
  end

  def grid([hash | remainder], index, bitmap) do
    offset = index*@ydim
    <<prefix::size(offset), _::size(@xdim), rest::bitstring>> = bitmap
    current = hash |> Base.decode16!
    grid(remainder, index+1, <<prefix::size(offset)>> <> current <> <<rest::bitstring>>)
  end

  def display(grid, limit \\ 16) do
    for(<<bit::1 <- grid>>, do: bit)
      |> Enum.reduce({"", 1}, fn(bit, {acc, index}) -> {
        acc
        <> (if rem(index, @xdim)<limit and div(index,@xdim)<limit, do: (if bit == 1, do: "#", else: "."), else: "")
        <> (if rem(index, @xdim) == 0 and div(index,@xdim)<limit, do: "\n", else: ""), index+1} end)
      |> Tuple.to_list
      |> Enum.at(0)
  end

  def regions(grid) do
    regions(grid, <<0::size(@size)>>, 0, 0)
  end

  def regions(_, _, offset, counter) when offset<0 or offset>=@size do
    counter
  end

  def regions(grid, visited, offset, counter) do
    <<_::size(offset), gbit::size(1), _::bitstring>> = grid
    <<vprefix::size(offset), vbit::size(1), vrest::bitstring>> = visited

    cond do
      vbit == 1 -> regions(grid, visited, offset+1, counter)
      gbit == 0 -> regions(grid, <<vprefix::size(offset), 1::size(1), vrest::bitstring>>, offset+1, counter)
      true -> regions(grid,
                      visit(grid, visited, offset),
                      offset+1,
                      counter+1)
    end
  end

  def visit(_, visited, offset) when offset<0 or offset>=@size do
    visited
  end

  def visit(grid, visited, offset) do
    <<_::size(offset), gbit::size(1), _::bitstring>> = grid
    <<vprefix::size(offset), vbit::size(1), vrest::bitstring>> = visited

    cond do
      vbit == 1 -> visited
      gbit == 0 -> <<vprefix::size(offset), 1::size(1), vrest::bitstring>>
      true -> new_visited = <<vprefix::size(offset), 1::size(1), vrest::bitstring>>
              new_visited = if rem(offset+1, @xdim) == 0, do: new_visited, else: visit(grid, new_visited, offset+1) ## requires rem prefix
              new_visited = if rem(offset, @xdim) == 0, do: new_visited, else: visit(grid, new_visited, offset-1) ## requires rem prefix
              new_visited = visit(grid, new_visited, offset+@xdim)
              visit(grid, new_visited, offset-@xdim)
    end
  end
end

string = input |> String.trim

hashlist =
  for(n <- 0..127, do: "#{string}-#{n}")
  |> Enum.map(&Day10.knot_hash/1)

hashlist
  |> Day14.used_blocks
  |> (&"The are #{&1} used blocks.").()
  |> IO.puts

hashlist
  |> Day14.grid
  |> Day14.display
  |> IO.puts

hashlist
  |> Day14.grid
  |> Day14.regions
  |> (&"The are #{&1} regions.").()
  |> IO.puts
