defmodule Utils do
  defmodule Table do
    def new(lines) do
      table =
        lines
        |> Enum.with_index(0)
        |> Enum.reduce(%{}, fn {line, line_number}, acc ->
          series = line |> Enum.with_index() |> Map.new(fn {v, idx} -> {idx, v} end)
          Map.put(acc, line_number, series)
        end)

      table
      |> Map.put(:max_row, length(lines) - 1)
      |> Map.put(:max_col, length(Enum.at(lines, 0)) - 1)
    end

    def insert_row(table, row_number, row) do
      row = Enum.with_index(row, 0) |> Map.new(fn {v, idx} -> {idx, v} end)

      table =
        Map.new(
          table,
          fn
            {r, cols} when is_integer(r) -> if r >= row_number, do: {r + 1, cols}, else: {r, cols}
            data -> data
          end
        )
        |> Map.put(row_number, row)

      table
      |> Map.put(:max_row, table[:max_row] + 1)
    end

    def insert_col(table, col_number, col) do
      col =
        Enum.with_index(col)
        |> Map.new(fn {v, idx} -> {idx, v} end)

      table =
        Map.new(table, fn
          {r, cols} when is_integer(r) ->
            new_cols =
              Map.new(cols, fn {c, val} ->
                if c >= col_number, do: {c + 1, val}, else: {c, val}
              end)
              |> Map.put(col_number, col[r])

            {r, new_cols}

          data ->
            data
        end)

      table
      |> Map.put(:max_col, table[:max_col] + 1)
    end
  end

  def print_tensor(tensor) do
    {x, _y} = Nx.shape(tensor)

    for r <- 0..(x - 1) do
      IO.write(Nx.to_list(tensor[r]))
      IO.write("\n")
    end

    tensor
  end

  def fast_table(lines), do: Table.new(lines)

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
