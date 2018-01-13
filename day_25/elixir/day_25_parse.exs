IO.puts "Day 25: The Halting Problem"

blocks = case File.read((__ENV__.file |> Path.dirname) <> "/../day_25.input") do
  {:ok, content} -> content |> String.trim |> String.split("\n\n")
  _ -> raise "Could not find input file. Please run from the exs file location."
end

init = blocks
  |> List.first
  |> String.split("\n")
  |> Enum.map(
    fn "Begin" <> remainder   -> {:Start, remainder |> String.split(" ") |> List.last |> String.slice(0..-2) |> String.to_atom}
       "Perform" <> remainder -> {:Stop, remainder |> String.split(" ") |> Enum.slice(-2..-2) |> List.first |> String.to_integer}
  end)
  |> Map.new

blueprint = blocks
  |> Enum.drop(1) # drop init block
  |> Enum.map(fn x -> x # convert blocks to list containing processable tokens
    |> String.split("\n")
    |> Enum.map(fn token -> token
      |> String.split(" ")
      |> List.last
      |> String.slice(0..-2)
      |> (fn x -> case Integer.parse(x) do {val, _} -> val; :error -> String.to_atom(x) end end).()
      |> (fn x -> case x do :right -> &+/2; :left -> &-/2; x -> x end end).()
    end)
  end)
  # convert lists/sublists to maps
  |> Enum.reduce(Map.new, fn [state | rest], acc ->
    Map.put(acc, state, rest |> Enum.chunk_every(4) |> Enum.reduce(Map.new, fn [value | ins], acc2 -> Map.put(acc2, value, ins |> List.to_tuple) end)) end)


Stream.unfold({ Map.get(init, :Start), Map.new, blueprint, 0, 0 },
  fn {state, band, blueprint, position, pc} = current -> {new_value, op, new_state} = blueprint |> Map.get(state) |> Map.get(Map.get(band, position, 0))
      {current, {new_state, (if new_value == 0, do: Map.delete(band, position), else: Map.put(band, position, new_value)), blueprint, op.(position, 1), pc+1}}
   end)
|> Stream.drop_while(fn {_, _, _, _, pc} -> pc < Map.get(init, :Stop) end)
|> Stream.take(1)
|> Enum.to_list
|> List.first
|> elem(1)
|> Map.size
|> (&"The diagnostic checksum is #{&1}.").()
|> IO.puts
