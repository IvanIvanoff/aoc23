defmodule Day3 do
  def get_input(), do: File.read!("./lib/inputs/day3")

  # Part A
  def run_a(input \\ get_input()) do
    numbered_lines = input |> Utils.split_lines() |> Enum.with_index()
    map_series = parse(numbered_lines)

    find_numbers(numbered_lines, map_series)
    |> Enum.map(& &1[:number])
    |> Enum.sum()
  end

  # Part B

  def run_b(input \\ get_input()) do
    numbered_lines = input |> Utils.split_lines() |> Enum.with_index()
    map_series = parse(numbered_lines)
    numbers = find_numbers(numbered_lines, map_series)
    find_gears_sum_value(map_series, numbers)
  end

  # Private

  defp parse(lines) do
    map_series =
      lines
      |> Enum.reduce(%{}, fn {line, line_number}, acc ->
        line = String.split(line, "", trim: true)
        series = Explorer.Series.from_list(line)
        Map.put(acc, line_number, series)
      end)

    map_series
    |> Map.put(:max_row, length(lines) - 1)
    |> Map.put(:max_col, String.length(Enum.at(lines, 0) |> elem(0)) - 1)
  end

  defp find_numbers(numbered_lines, map_series) do
    Enum.flat_map(numbered_lines, fn {line, line_number} ->
      indexes = Regex.scan(~r/(\d+)/, line, return: :index, capture: :all_but_first)

      Enum.reduce(indexes, [], fn [{start, len}], acc ->
        case get_adjecent_symbols(map_series, line_number, start, start + len - 1) do
          [] ->
            acc

          _ ->
            num = String.to_integer(String.slice(line, start, len))
            elem = %{number: num, line_number: line_number, start: start, end: start + len - 1}
            [elem | acc]
        end
      end)
    end)
  end

  defp find_gears_sum_value(map_series, numbers) do
    for r <- 0..map_series.max_row,
        c <- 0..map_series.mac_col do
      val = map_series[r][c]

      case val == "*" && get_adjecent_numbers(numbers, map_series, r, c) do
        [%{number: num1}, %{number: num2}] -> num1 * num2
        _ -> 0
      end
    end
    |> Enum.sum()
  end

  defp get_adjecent_symbols(map_series, row, col_start, col_end) do
    for r <- (row - 1)..(row + 1),
        c <- (col_start - 1)..(col_end + 1),
        r in 0..map_series.max_row,
        c in 0..map_series.max_col do
      val = map_series[r][c]
      {row, {col_start, col_end}, {r, c}, val}
      if val not in ~w(. 0 1 2 3 4 5 6 7 8 9), do: val, else: nil
    end
    |> Enum.reject(&is_nil/1)
  end

  defp get_adjecent_numbers(numbers, map_series, row, col) do
    for r <- (row - 1)..(row + 1), r in 0..map_series.max_row do
      numbers = numbers |> Enum.filter(&(&1.line_number == r))

      Enum.filter(numbers, fn num ->
        not Range.disjoint?((col - 1)..(col + 1), num.start..num.end)
      end)
    end
    |> List.flatten()
  end
end
