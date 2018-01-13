IO.puts "Day 01: Inverse Captcha"

input = case File.read((__ENV__.file |> Path.dirname) <> "/../day_01.input") do
  {:ok, content} -> content
  _ -> raise "Could not find input file. Please run from the exs file location."
end

# convert to int list
list = input
  |> String.trim
  |> String.graphemes
  |> Enum.map(&String.to_integer/1)

## Computation of successor equality sum
## Simulate circle buffer by appending first element to the list
## and reduce the list over a tuple accumulator which holds the sum and the
## previous element.
#list ++ [Enum.at(list, 0)]
#  |> Enum.reduce({0, 0}, fn x, {acc, last} -> if x == last, do: {acc+x, x}, else: {acc, x} end)
#  |> elem(0)
#  |> (&"The solution to the capture is #{&1}.").()
#  |> IO.puts
## result: 1034
#
## For the second part, we shift the list by half the length and zip it with
## the original one.
#Enum.chunk_every(list, div(length(list),2))
#	|> Enum.reverse
#	|> Enum.concat
#	|> Enum.zip(list)
#	|> Enum.reduce(0, fn {x, y}, acc -> if x == y, do: acc+x, else: acc end)
#  |> (&"The solution to the new capture is #{&1}.").()
#	|> IO.puts
## result: 1356

# Another way to do it—just for the sake of a single "simple" pipeline.
input
	|> String.trim
	|> String.to_integer
	|> Integer.digits
	|> Enum.split(1)
	|> Tuple.to_list
	|> Enum.reverse
	|> Enum.concat
	|> Enum.zip(list)
	|> Enum.filter(fn {x, y} -> x == y end)
	|> Enum.reduce(0 , fn {x, _}, acc -> acc+x end)
  |> (&"The solution to the capture is #{&1}.").()
	|> IO.puts
# result: 1034

# and the same as before
input
	|> String.trim
	|> String.to_integer
	|> Integer.digits
	|> Enum.split(div(length(list), 2))
	|> Tuple.to_list
	|> Enum.reverse
	|> Enum.concat
	|> Enum.zip(list)
	|> Enum.filter(fn {x, y} -> x == y end)
	|> Enum.reduce(0 , fn {x, _}, acc -> acc+x end)
  |> (&"The solution to the new capture is #{&1}.").()
	|> IO.puts
# result: 1356
