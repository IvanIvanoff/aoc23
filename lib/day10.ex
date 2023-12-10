defmodule Day10 do
  def get_input(), do: File.read!("./lib/inputs/day10") |> Utils.split_lines_twice() |> parse()

  # Part A
  def run_a() do
    get_input() |> find_farthest_position()
  end

  # Part B

  def run_b() do
    get_input()
  end

  defp parse(lines) do
    {_row, _col} =
      start =
      Enum.with_index(lines)
      |> Enum.find(fn {l, _} -> Enum.any?(l, &(&1 == "S")) end)
      |> case do
        {line, line_number} -> {line_number, Enum.find_index(line, &(&1 == "S"))}
      end

    lines
    |> Utils.fast_table()
    |> Map.put(:start_position, start)
  end

  defp find_farthest_position(%{start_position: s} = table) do
    do_find(
      table,
      {s, find_next(table, nil, s, :left)},
      {s, find_next(table, nil, s, :right)},
      0
    )
  end

  defp do_find(table, {prev_l, l}, {prev_r, r}, len, r_len) do
    if len > 8000, do: raise("Too much")

    if l == r do
      len + 1
    else
      do_find(
        table,
        {l, find_next(table, prev_l, l)},
        {r, find_next(table, prev_r, r)},
        len + 1
      )
    end
  end

  defp find_next(table, prev, {x, y}, direction \\ nil) do
    pos =
      for {r, c} <- [{x, y - 1}, {x, y + 1}, {x - 1, y}, {x + 1, y}],
          {r, c} != prev,
          r in 0..table.max_row,
          c in 0..table.max_col,
          table[r][c] in ~w(S J L 7 F | -),
          pipe_allowed?(table, {x, y}, {r, c}),
          do: {r, c}

    cond do
      direction == nil -> Enum.at(pos, 0)
      direction == :left -> Enum.at(pos, 0)
      direction == :right -> Enum.at(pos, 1)
    end
  end

  defp pipe_allowed?(table, {x1, y1}, {x2, y2}) do
    from = table[x1][y1]
    to = table[x2][y2]

    cond do
      from == "S" or to == "S" -> true
      y1 > y2 and from in ~w(- J 7) -> to in ~w(- F L)
      y1 < y2 and from in ~w(- F L) -> to in ~w(- J 7)
      x1 > x2 and from in ~w(| J L) -> to in ~w(| F 7)
      x1 < x2 and from in ~w(| F 7) -> to in ~w(| J L)
      true -> false
    end
  end
end
