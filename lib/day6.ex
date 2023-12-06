defmodule Day6 do
  def get_input(), do: File.read!("./lib/inputs/day6")

  # Part A
  def run_a(input \\ get_input()) do
    input
    |> Utils.split_lines()
    |> parse()
    |> get_counts()
    |> Enum.reduce(1, &(&1 * &2))
  end

  # Part B

  def run_b(input \\ get_input()) do
    input
    |> Utils.split_lines()
    |> parse_kerning()
    |> get_counts()
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp parse(lines) do
    ["Time: " <> time_str, "Distance: " <> distance_str] = lines
    Enum.zip(to_numbers(time_str), to_numbers(distance_str))
  end

  defp parse_kerning(lines) do
    ["Time: " <> time_str, "Distance: " <> distance_str] = lines
    [{to_numbers_kerning(time_str), to_numbers_kerning(distance_str)}]
  end

  defp to_numbers(s), do: s |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
  defp to_numbers_kerning(s), do: s |> String.replace(" ", "") |> String.to_integer()

  defp get_counts(list) do
    # Each element is a tuple {time, distance}
    # We need to solve for the positive values of x in: (time - x)*x > distance
    # i.e. x^2 - time*x + distance < 0, which is all the integers between the roots of the equation
    Enum.map(list, fn {time, distance} ->
      d = :math.sqrt(time * time - 4 * 1 * distance)
      x1 = (-time - d) / 2
      x2 = (-time + d) / 2
      x1_ceil = Float.ceil(x1)
      x2_floor = Float.floor(x2)

      corrections = [x1 == x1_ceil, x2 == x2_floor] |> Enum.count(& &1)
      abs(trunc(x2_floor - x1_ceil)) + 1 - corrections
    end)
  end
end
