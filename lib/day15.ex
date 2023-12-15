defmodule Day15 do
  def get_input(), do: File.read!("./lib/inputs/day15") |> String.split(",", trim: true)
  def run_a(), do: get_input() |> Enum.map(&hash/1) |> Enum.sum()
  def run_b(), do: get_input() |> build_hash_map() |> eval()

  defp build_hash_map(input) do
    Enum.reduce(input, %{}, fn l, acc ->
      case String.split(l, ["=", "-"], trim: true) do
        [box, _] = slot -> Map.update(acc, hash(box), [slot], &add_lens(&1, slot))
        [box] -> Map.update(acc, hash(box), [], &remove_lens(&1, box))
      end
    end)
  end

  defp eval(hash_map), do: Enum.flat_map(hash_map, &box_lenses_values/1) |> Enum.sum()

  defp box_lenses_values({box, lenses}) do
    Enum.with_index(lenses, 1)
    |> Enum.map(fn {[_, l], i} -> (box + 1) * String.to_integer(l) * i end)
  end

  def hash(binary, hash_value \\ 0)
  def hash(<<c::size(8), r::binary>>, hash), do: hash(r, rem((hash + c) * 17, 256))
  def hash(<<>>, hash), do: hash

  defp add_lens(list, [box, _] = slot) do
    case Enum.find_index(list, fn [b, _] -> b == box end) do
      nil -> list ++ [slot]
      index -> List.replace_at(list, index, slot)
    end
  end

  defp remove_lens(list, box), do: Enum.reject(list, fn [b, _] -> b == box end)
end
