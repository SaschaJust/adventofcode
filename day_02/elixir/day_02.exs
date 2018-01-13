IO.puts "Day 02: Corruption Checksum"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_02.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

input
  |> String.trim
  |> String.split("\n")
  |> Enum.reduce(0, fn x, acc_x -> acc_x +
    (x
      |> String.split("\t")
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce({nil, nil}, fn y, {acc_a, acc_b} ->
        { (if acc_a == nil or y < acc_a, do: y, else: acc_a),
          (if acc_b == nil or y > acc_b, do: y, else: acc_b) }
        end)
        |> Tuple.to_list
        |> Enum.reduce({0, -1}, fn x, {sum, sign} -> {sum + sign * x, -sign} end)
        |> elem(0)
    ) end)
  |> (&"The checksum for the spreadsheet is #{&1}.").()
  |> IO.puts
# result: 48357

input
  |> String.trim
  |> String.split("\n")
  |> Enum.reduce(0, fn x, acc_x -> acc_x +
    (x |> String.split("\t")
       |> Enum.map(&String.to_integer/1)
       |> (&Enum.reduce(&1, {nil, nil}, fn x, {divisor, divider} ->
              if divider == nil, do: {x, Enum.find(&1, fn y -> x != y and rem(x, y) == 0 end)}, else: {divisor, divider}
          end)).()
       |> Tuple.to_list
       |> Enum.reduce(0, fn x, result -> if result == 0, do: x, else: div(result, x) end))
    end)
  |> (&"The sum of each row's result is #{&1}.").()
  |> IO.puts
# result: 351
