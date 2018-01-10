use Bitwise

defmodule Day25 do
  @compile {:inline, translate: 1}
  def translate(position) do
    cond do
      position < 0 -> 2*(-position)
      true -> 2*position + 1
    end
  end

  def get(band, position) do
    index = position |> translate
    cond do
      index > bit_size(band) -> 0
      true -> offset = index - 1
           <<_::size(offset),bit::1,_::bitstring>> = band
           bit
    end
  end

  def set(band, position, value) when value <= 1 do
    index = position |> translate
    offset = index - 1

    band =
    cond do
      bit_size(band) <= index -> append_size = bit_size(band); band <> <<0::size(append_size)>>
      true -> band
    end

    <<lhs::size(offset), _::size(1), rhs::bitstring>> = band
    <<lhs::size(offset), value::size(1), rhs::bitstring>>
  end

  def act(band \\ <<0::size(1_000_000)>>, position \\ 0, state \\ :A, pc \\ 0)

  def act(band, _, _, 12_919_244) do
    for(<<bit::1 <- band>>, do: bit) |> Enum.sum
  end

  def act(band, position, :A, pc) do
    case band |> get(position) do
      0 -> act(set(band, position, 1), position+1, :B, pc+1)
      1 -> act(set(band, position, 0), position-1, :C, pc+1)
    end
  end

  def act(band, position, :B, pc) do
    case band |> get(position) do
      0 -> act(set(band, position, 1), position-1, :A, pc+1)
      1 -> act(band, position+1, :D, pc+1)
    end
  end

  def act(band, position, :C, pc) do
    case band |> get(position) do
      0 -> act(set(band, position, 1), position+1, :A, pc+1)
      1 -> act(set(band, position, 0), position-1, :E, pc+1)
    end
  end

  def act(band, position, :D, pc) do
    case band |> get(position) do
      0 -> act(set(band, position, 1), position+1, :A, pc+1)
      1 -> act(set(band, position, 0), position+1, :B, pc+1)
    end
  end

  def act(band, position, :E, pc) do
    case band |> get(position) do
      0 -> act(set(band, position, 1), position-1, :F, pc+1)
      1 -> act(band, position-1, :C, pc+1)
    end
  end

  def act(band, position, :F, pc) do
    case band |> get(position) do
      0 -> act(set(band, position, 1), position+1, :D, pc+1)
      1 -> act(band, position+1, :A, pc+1)
    end
  end
end

Day25.act
  |> (&"The diagnostic checksum is #{&1}.").()
  |> IO.puts
