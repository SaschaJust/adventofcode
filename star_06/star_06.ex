{_, input} = File.read("star_06.input")
map = input \
  |> String.trim \
  |> String.split("\t") \
  |> Enum.with_index \
  |> Enum.map(fn {x, y} -> {y,String.to_integer x} end) \
  |> Map.new

defmodule Star06 do
  def distribute({key, value}, blocks,  init? \\ false) do
    cond do
      init? -> distribute({rem(key+1, Map.size(blocks)), value}, Map.put(blocks, key, 0))
      value == 0 -> blocks
      true -> distribute({rem(key+1, Map.size(blocks)), value-1}, Map.put(blocks, key, Map.get(blocks, key) + 1))
    end
  end

  def balance1(blocks, states, counter) do
      cond do
        MapSet.member?(states, blocks) -> counter
        true -> balance1(
          blocks \
          |> Map.to_list \
          |> Enum.reduce(fn ({x, y}, {key, max}) -> if y > max, do: {x, y}, else: {key, max} end) \
          |> distribute(blocks, true),
        MapSet.put(states, blocks),
        counter+1)
      end
  end

  def balance2(blocks, states, ref, counter) do
      cond do
        MapSet.member?(states, blocks) -> cond do
          ref == nil -> balance2(
            blocks \
              |> Map.to_list \
              |> Enum.reduce(fn ({x, y}, {key, max}) -> if y > max, do: {x, y}, else: {key, max} end) \
              |> distribute(blocks, true),
            MapSet.put(states, blocks),
            blocks,
            counter + 1)
          ref == blocks -> counter
          true -> balance2(
            blocks \
              |> Map.to_list \
              |> Enum.reduce(fn ({x, y}, {key, max}) -> if y > max, do: {x, y}, else: {key, max} end) \
              |> distribute(blocks, true),
          MapSet.put(states, blocks),
          ref,
          counter+1)

        end
        true -> balance2(
          blocks \
            |> Map.to_list \
            |> Enum.reduce(fn ({x, y}, {key, max}) -> if y > max, do: {x, y}, else: {key, max} end) \
            |> distribute(blocks, true),
        MapSet.put(states, blocks),
        ref,
        counter)
      end
  end
end

map |> Star06.balance1(MapSet.new(), 0) |> IO.puts
map |> Star06.balance2(MapSet.new(), nil, 0) |> IO.puts
