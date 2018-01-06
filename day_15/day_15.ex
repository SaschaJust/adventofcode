use Bitwise
input_gen_a = 679
input_gen_b = 771

# input_gen_a = 65
# input_gen_b = 8921

defmodule Star15 do
  @seed_a 16807
  @seed_b 48271
  @rem 2147483647

  def generate(_, _, 0, _) do
    []
  end

  def generate(prev, seed, count, mod) do
    p=rem(prev*seed,@rem)
    case rem(p,mod) do
      0 -> [ p | generate(p, seed, count-1, mod) ]
      _ -> generate(p, seed, count, mod)
    end

  end

  def agreements(input_a, input_b, iterations, mod_a \\ 1, mod_b \\ 1) do
    Enum.zip(input_a |> generate(@seed_a, iterations, mod_a), input_b |> generate(@seed_b, iterations, mod_b))
      |> Enum.count(fn({a,b}) -> (a&&&0xFFFF) == (b&&&0xFFFF) end)
  end
end

Star15.agreements(input_gen_a,input_gen_b,40000000)
  |> (&"There are #{&1} agreements.").()
  |> IO.inspect

Star15.agreements(input_gen_a,input_gen_b,5000000,4,8)
  |> (&"There are #{&1} agreements.").()
  |> IO.inspect
