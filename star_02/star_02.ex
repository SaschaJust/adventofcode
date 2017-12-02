{_, input} = File.read("star_02.input")

input \
|> String.trim \
|> String.split("\n") \
|> Enum.reduce(0, fn(x, acc_x) -> acc_x +
  (x \
  |> String.split("\t") \
  |> Enum.map(fn(x) -> String.to_integer(x) end) \
  |> Enum.reduce({nil, nil}, fn(y, {acc_a, acc_b}) ->
    { (if acc_a == nil or y < acc_a do y else acc_a end),
      (if acc_b == nil or y > acc_b do y else acc_b end) }
    end) \
  |> Tuple.to_list \
  |> Enum.reduce({0, -1}, fn(x, {sum, sign}) -> {sum + sign * x, -sign} end) \
  |> elem(0)) end) \
|> IO.puts
# result: 48357

input \
|> String.trim \
|> String.split("\n") \
|> Enum.reduce(0, fn(x, acc_x) -> acc_x +
  (x \
  |> String.split("\t") \
  |> Enum.map(fn(x) -> String.to_integer(x) end) \
  |> (&Enum.reduce(&1, {nil, nil}, fn(x, {divisor, divider}) ->
    if divider == nil do {x, Enum.find(&1, fn(y) -> x != y and rem(x, y) == 0 end)} else {divisor, divider} end
   end)).() \
  |> Tuple.to_list \
  |> Enum.reduce(0, fn(x, result) -> if result == 0 do x else div(result, x) end end))
end) \
|> IO.puts
# result: 351
