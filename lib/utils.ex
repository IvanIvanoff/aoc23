defmodule Utils do
  def fast_table(lines) do
    map_series =
      lines
      |> Enum.with_index(0)
      |> Enum.reduce(%{}, fn {line, line_number}, acc ->
        # series = Explorer.Series.from_list(line)
        series = line |> Enum.with_index() |> Map.new(fn {v, idx} -> {idx, v} end)
        Map.put(acc, line_number, series)
      end)

    map_series
    |> Map.put(:max_row, length(lines) - 1)
    |> Map.put(:max_col, length(Enum.at(lines, 0)) - 1)
  end

  def split_lines(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reject(&(&1 == ""))
  end

  def split_lines_twice(input, sep \\ "") do
    input
    |> String.split("\n", trim: true)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.split(&1, sep, trim: true))
  end

  def consecutive_diff(list) do
    Enum.chunk_every(list, 2, 1, :discard) |> Enum.map(fn [x, y] -> y - x end)
  end
end
