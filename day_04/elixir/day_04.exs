{:ok, input} = File.read("../day_04.input")

input \
  |> String.trim \
  |> String.split("\n") \
  |> Enum.filter(fn(x) ->
    (x \
      |> String.split(" ") \
      |> (&Enum.count(&1) == (&1 |> Enum.uniq |> Enum.count)).()
    ) end)
  |> Enum.count
  |> IO.puts
# result: 383

input \
  |> String.trim \
  |> String.split("\n") \
  |> Enum.filter(fn(x) ->
    (x \
      |> String.split(" ") \
      |> Enum.map(fn(x) -> x |> String.graphemes |> Enum.sort end)
      |> (&Enum.count(&1) == (&1 |> Enum.uniq |> Enum.count)).()
    ) end)
  |> Enum.count
  |> IO.puts
# result 265
