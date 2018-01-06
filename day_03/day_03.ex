input = 368078

defmodule Star03 do
  def part1(block, {x, y}, step, direction, index, target) do
    cond do
      index >= target -> abs(x) + abs(y)
      step == 0 -> new_block = if direction == 3 do block+1 else block end; new_direction = rem(direction+1,4); part1(new_block, {x, y}, 2*new_block+1+div(new_direction,2), new_direction, index, target)
      true -> part1(block,
        case direction do
          0 -> {x+1, y}
          1 -> {x, y+1}
          2 -> {x-1, y}
          3 -> {x, y-1}
          _ -> raise "Invalid direction"
        end,
        step-1,
        direction,
        index+1,
        target
        )
    end
  end

  def part2(block, {x, y}, step, direction, grid, value, target) do
    cond do
      value > target -> value
      step == 0 -> new_block = if direction == 3 do block+1 else block end; new_direction = rem(direction+1,4); part2(new_block, {x, y}, 2*new_block+1+div(new_direction,2), new_direction, grid, value, target)
      true -> compute = fn (f, grid, {x, y}, offsets, sum) ->
          case offsets do
            [] -> Map.put_new(grid, {x, y}, sum)
            [ {a, b} | remainder ] -> f.(f, grid, {x, y}, remainder, sum + Map.get(grid, {a, b}, 0))
            _ -> raise "Invalid input"
          end
        end;
        grid=compute.(compute, grid, {x, y}, for i <- x-1..x+1, j <- y-1..y+1 do {i, j} end, 0); 
        part2(block,
        case direction do
          0 -> {x+1, y}
          1 -> {x, y+1}
          2 -> {x-1, y}
          3 -> {x, y-1}
          _ -> raise "Invalid direction"
        end,
        step-1,
        direction,
        grid,
        Map.get(grid, {x, y}, 0),
        target
        )
    end
  end
end

Star03.part1(0, {0, 0}, 1, 0, 1, input)
|> IO.puts
# result: 371

Star03.part2(0, {0, 0}, 1, 0, Map.new([{{0,0}, 1}]), 0, input)
|> IO.puts
# result: 369601
