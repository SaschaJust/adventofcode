use Bitwise
{:ok, input} = File.read("star_10.input")

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

input
  |> String.trim
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)
  |> Day10.pinch(Enum.to_list(0..255), 0, 0)
  |> Enum.take(2)
  |> Enum.reduce(1, &*/2)
  |> IO.puts
# result: 4114

input |> Day10.knot_hash |> IO.puts
# result: 2F8C3D2100FDD57CEC130D928B0FD2DD
