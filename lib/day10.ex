defmodule Day10 do
  def get_input(), do: File.read!("./lib/inputs/day10") |> Utils.split_lines_twice() |> parse()

  # Part A
  def run_a() do
    get_input() |> find_farthest_position()
  end

  # Part B

  def run_b() do
    get_input() |> find_loop_area()
  end

  defp parse(lines) do
    {line, line_number} =
      Enum.with_index(lines) |> Enum.find(fn {l, _} -> Enum.any?(l, &(&1 == "S")) end)

    start = {line_number, Enum.find_index(line, &(&1 == "S"))}

    lines
    |> Utils.fast_table()
    |> Map.put(:start_position, start)
  end

  defp find_farthest_position(%{start_position: s} = table) do
    path = do_find(table, s, find_next(table, nil, s), [])
    div(length(path), 2)
  end

  defp find_loop_area(%{start_position: s} = table) do
    path = do_find(table, s, find_next(table, nil, s), [])
    compute_area(table, path)
  end

  defp compute_area(table, path) do
    path_mapset = MapSet.new(path)

    path_map =
      Enum.reduce(path, %{}, fn {x, y}, acc -> Map.update(acc, x, [y], &[y | &1]) end)
      |> Map.new(fn {line_number, cols} ->
        cols =
          Enum.sort(cols, :asc)
          |> Enum.map(fn c -> {c, table[line_number][c]} end)

        {line_number, cols}
      end)

    points =
      for r <- 0..table.max_row,
          c <- 0..table.max_col,
          {r, c} not in path_mapset,
          inside_loop?({r, c}, path_map),
          do: {r, c}

    print_table(table, MapSet.new(points), path_mapset)
    length(points)
  end

  defp inside_loop?({x, y}, path_map) do
    points_to_the_left =
      Map.get(path_map, x, [])
      |> Enum.reduce([], fn {col, point}, acc ->
        if col < y, do: [point | acc], else: acc
      end)

    inversions = Enum.count(points_to_the_left, fn x -> x in ["|", "J", "L"] end)
    rem(inversions, 2) == 1
  end

  defp do_find(table, prev, {x, y} = curr, path) do
    if table[x][y] == "S" do
      [curr | path]
    else
      do_find(table, curr, find_next(table, prev, curr), [curr | path])
    end
  end

  def find_next(table, prev, {x, y}), do: hd(connected(table, prev, {x, y}))

  defp connected(table, prev, {x, y}) do
    for {r, c} <- [{x, y - 1}, {x - 1, y}, {x, y + 1}, {x + 1, y}],
        {r, c} != prev,
        r in 0..table.max_row,
        c in 0..table.max_col,
        table[r][c] != ".",
        pipe_allowed?(table, {x, y}, {r, c}),
        do: {r, c}
  end

  defp pipe_allowed?(table, {x1, y1}, {x2, y2}) do
    from = table[x1][y1]
    to = table[x2][y2]

    cond do
      y1 > y2 and (from in ~w(S - J 7) and to in ~w(S - F L)) -> true
      y1 < y2 and (from in ~w(S - F L) and to in ~w(S - J 7)) -> true
      x1 > x2 and (from in ~w(S | J L) and to in ~w(S | F 7)) -> true
      x1 < x2 and (from in ~w(S | F 7) and to in ~w(S | J L)) -> true
      true -> false
    end
  end

  def print_table(table, inside_mapset, path_mapset) do
    for r <- 0..table.max_row,
        c <- 0..table.max_col do
      color =
        cond do
          {r, c} in inside_mapset -> IO.ANSI.green()
          {r, c} in path_mapset -> IO.ANSI.red()
          true -> IO.ANSI.yellow()
        end

      IO.write(color <> table[r][c])
      IO.ANSI.reset()
      if c == table.max_col, do: IO.write("\n")
    end
  end
end
