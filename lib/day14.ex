defmodule Day14 do
  def get_input(),
    do: File.read!("./lib/inputs/day14") |> Utils.split_lines_twice() |> parse()

  def run_a(), do: get_input() |> tilt(:north) |> compute_weight(:north)

  def run_b() do
    table = get_input()
    dirs = [:north, :west, :south, :east]

    Enum.reduce_while(1..1_000_000_000, {table, %{}, %{}}, fn i, {c, seen, weights} ->
      next = Enum.reduce(dirs, c, fn dir, curr_acc -> tilt(curr_acc, dir) end)
      weight = compute_weight(next, :north)

      if start_cycle = Map.get(seen, next) do
        idx_in_cycle = rem(1_000_000_000 - start_cycle, i - start_cycle)

        {:halt, Map.get(weights, start_cycle + idx_in_cycle)}
      else
        {:cont, {next, Map.put(seen, next, i), Map.put(weights, i, weight)}}
      end
    end)
  end

  def tilt(table, tilt_direction) do
    points = get_points(table, tilt_direction)

    Enum.reduce(points, table, fn curr, acc ->
      case acc[curr] do
        "#" ->
          acc

        "O" ->
          acc

        "." ->
          if p = find_rolling_stone(acc, curr, tilt_direction),
            do: Map.merge(acc, %{curr => "O", p => "."}),
            else: acc
      end
    end)
  end

  defp get_points(table, tilt_direciton) do
    {x_gen, y_gen} =
      case tilt_direciton do
        :north -> {0..table.max_row, 0..table.max_col}
        :east -> {0..table.max_row, table.max_col..0}
        :south -> {table.max_row..0, 0..table.max_col}
        :west -> {table.max_row..0, 0..table.max_col}
      end

    for x <- x_gen, y <- y_gen, do: {x, y}
  end

  def compute_weight(table, tild_direction) do
    for r <- 0..table.max_row, c <- 0..table.max_col, table[{r, c}] == "O" do
      case tild_direction do
        :north -> table.max_row + 1 - r
        :south -> r + 1
        :east -> table.max_col + 1 - c
        :west -> c + 1
      end
    end
    |> Enum.sum()
  end

  defp check_point(table, point) do
    case table[point] do
      "#" -> {:halt, nil}
      "O" -> {:halt, point}
      "." -> {:cont, nil}
    end
  end

  defp find_rolling_stone(table, {r, c}, :north) do
    Enum.reduce_while(r..table.max_row, nil, fn x, _ -> check_point(table, {x, c}) end)
  end

  defp find_rolling_stone(table, {r, c}, :south) do
    Enum.reduce_while(r..0, nil, fn x, _ -> check_point(table, {x, c}) end)
  end

  defp find_rolling_stone(table, {r, c}, :east) do
    Enum.reduce_while(c..0, nil, fn y, _ -> check_point(table, {r, y}) end)
  end

  defp find_rolling_stone(table, {r, c}, :west) do
    Enum.reduce_while(c..table.max_col, nil, fn y, _ -> check_point(table, {r, y}) end)
  end

  defp parse(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, line_number}, acc ->
      line
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {v, idx}, acc -> Map.put(acc, {line_number, idx}, v) end)
    end)
    |> Map.put(:max_row, length(lines) - 1)
    |> Map.put(:max_col, length(hd(lines)) - 1)
  end

  def print(table) do
    for r <- 0..table.max_row do
      for c <- 0..table.max_col do
        IO.write(table[{r, c}])
      end

      IO.write("\n")
    end

    table
  end
end
