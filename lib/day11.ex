defmodule Day11 do
  import Utils, only: [split_lines_twice: 1, fast_table: 1]

  def get_input(), do: File.read!("./lib/inputs/day11") |> split_lines_twice() |> fast_table

  def run_a(), do: get_input() |> compute_min_distances(2 - 1) |> Enum.sum()
  def run_b(), do: get_input() |> compute_min_distances(1_000_000 - 1) |> Enum.sum()

  defp compute_min_distances(table, mult) do
    galaxy_pairs = galaxy_pairs(table)
    empty = find_empty(table)

    for [{x1, y1}, {x2, y2}] <- galaxy_pairs do
      added_rows = Enum.count(empty.empty_rows, &(&1 in x1..x2))
      added_cols = Enum.count(empty.empty_cols, &(&1 in y1..y2))

      abs(x1 - x2) + added_rows * mult + abs(y1 - y2) + added_cols * mult
    end
  end

  defp galaxy_pairs(table) do
    galaxies =
      for r <- 0..table.max_row, c <- 0..table.max_col, table[r][c] == "#" do
        {r, c}
      end

    for {x1, y1} <- galaxies, {x2, y2} <- galaxies, {x1, y1} != {x2, y2} do
      [{x1, y1}, {x2, y2}] |> Enum.sort()
    end
    |> MapSet.new()
  end

  defp find_empty(table) do
    empty_rows =
      Enum.reduce(0..table.max_row, [], fn r, acc ->
        if Enum.all?(table[r], fn {_, v} -> v == "." end), do: [r | acc], else: acc
      end)

    empty_cols =
      Enum.reduce(0..table.max_col, [], fn c, acc ->
        if Enum.all?(0..table.max_row, fn r -> table[r][c] == "." end), do: [c | acc], else: acc
      end)

    %{empty_rows: empty_rows, empty_cols: empty_cols}
  end
end
