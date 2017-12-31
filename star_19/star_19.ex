{:ok, input} = File.read "star_19.input"

defmodule Star19 do
  def get(matrix, {x, y}) do
    matrix |> Map.get(y) |> Map.get(x, " ")
  end

  def step(matrix, {right, down} = dir, {x, y} = p, accumulator, counter) do
    case get(matrix, p) do
      char when char == "|" or char == "-" -> step(matrix, dir, {x+right, y+down}, accumulator, counter+1)
      "+" -> cond do
              get(matrix, {x+down, y+right}) != " " -> step(matrix, {down, right}, {x+down, y+right}, accumulator, counter+1)
              true -> step(matrix, {-down, -right}, {x-down, y-right}, accumulator, counter+1)
             end
      " " -> {accumulator, counter}
      character -> step(matrix, dir, {x+right, y+down}, accumulator <> character, counter+1)
    end
  end
end

matrix = input
  |> String.split("\n")
  |> Enum.map(fn (x) -> x |> String.graphemes |> Enum.with_index |> Enum.map(fn({x, y}) -> {y, x} end) |> Map.new end)
  |> Enum.with_index
  |> Enum.map(fn({x, y}) -> {y, x} end)
  |> Map.new

start = matrix
  |> Map.get(0)
  |> Map.to_list
  |> Enum.find(fn({_, value}) -> value == "|" end)
  |> elem(0)

matrix
  |> Star19.step({0, 1}, {start, 0}, "", 0)
  |> (&"Took #{&1 |> elem(1)} steps and found trace #{&1 |> elem(0)}.").()
  |> IO.puts
