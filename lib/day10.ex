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
    do_find(table, {94, 98}, find_next(table, nil, s), 0)
  end

  defp do_find(table, prev, {x, y} = curr, len) do
    if table[x][y] == "S" do
      div(len + 1, 2)
    else
      do_find(
        table,
        curr,
        find_next(table, prev, curr),
        len + 1
      )
    end
  end

  def find_next(table, prev, {x, y}) do
    case connected(table, prev, {x, y}) do
      [next | _] -> next
      [] -> raise("Err, no next for #{inspect({x, y})}})}")
    end
  end

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
    f = table[x1][y1]
    t = table[x2][y2]

    cond do
      y1 > y2 and (f in ~w(S - J 7) and t in ~w(S - F L)) -> true
      y1 < y2 and (f in ~w(S - F L) and t in ~w(S - J 7)) -> true
      x1 > x2 and (f in ~w(S | J L) and t in ~w(S | F 7)) -> true
      x1 < x2 and (f in ~w(S | F 7) and t in ~w(S | J L)) -> true
      true -> false
    end
  end
end
