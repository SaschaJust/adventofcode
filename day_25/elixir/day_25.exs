use Bitwise

IO.puts "Day 25: The Halting Problem"

defmodule Day25 do
  @compile{:inline, get: 2}
  defp get(band, position), do: Map.get(band, position, 0)

  @compile{:inline, set: 3}
  defp set(band, position, 0), do: Map.delete(band, position)
  defp set(band, position, value), do: Map.put(band, position, value)

  def act(band \\ Map.new, position \\ 0, state \\ :A, pc \\ 0)

  def act(band, _, _, 12_919_244) do
    Map.size(band)
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
