defmodule Day16 do
  def get_input(), do: File.read!("./lib/inputs/day16") |> Utils.split_lines() |> parse()

  def run_a() do
    get_input() |> beam()
  end

  def run_b() do
    get_input()
  end

  defp beam(tensor) do
    seen = trace_beam(tensor, {0, 0, :left}, [], MapSet.new())
    print_path(tensor, seen)

    seen = seen |> MapSet.new(fn {x, y, _dir} -> {x, y} end)

    seen |> MapSet.size()
  end

  defp trace_beam(tensor, {x, y, dir}, stack, seen) do
    cond do
      not valid_point?(tensor, {x, y}) and stack == [] ->
        seen

      not valid_point?(tensor, {x, y}) and stack != [] ->
        trace_beam(tensor, hd(stack), tl(stack), seen)

      valid_point?(tensor, {x, y}) and not MapSet.member?(seen, {x, y, dir}) ->
        char = Nx.to_number(tensor[x][y])

        [next | next_rest] = move(char, x, y, dir)

        trace_beam(tensor, next, next_rest ++ stack, MapSet.put(seen, {x, y, dir}))

      valid_point?(tensor, {x, y}) and MapSet.member?(seen, {x, y, dir}) ->
        case stack do
          [] -> seen
          [next | rest_stack] -> trace_beam(tensor, next, rest_stack, seen)
        end
    end
  end

  defp valid_point?(tensor, {x, y}) do
    {r, c} = Nx.shape(tensor)
    x in 0..(r - 1) and y in 0..(c - 1)
  end

  defp parse(lines) do
    lines
    |> Enum.map(fn l -> String.split(l, "", trim: true) |> Enum.map(&to_num/1) end)
    |> Nx.tensor()
  end

  defp to_num(<<char::size(8)>>), do: char

  defp move(?., x, y, :left), do: [{x, y + 1, :left}]
  defp move(?., x, y, :right), do: [{x, y - 1, :right}]
  defp move(?., x, y, :down), do: [{x + 1, y, :down}]
  defp move(?., x, y, :up), do: [{x - 1, y, :up}]

  defp move(?-, x, y, :left), do: [{x, y + 1, :left}]
  defp move(?-, x, y, :right), do: [{x, y - 1, :right}]
  defp move(?-, x, y, dir) when dir in [:down, :up], do: [{x, y - 1, :right}, {x, y + 1, :left}]

  defp move(?|, x, y, :down), do: [{x + 1, y, :down}]
  defp move(?|, x, y, :up), do: [{x - 1, y, :up}]
  defp move(?|, x, y, dir) when dir in [:left, :right], do: [{x - 1, y, :up}, {x + 1, y, :down}]

  defp move(?\\, x, y, :left), do: [{x + 1, y, :down}]
  defp move(?\\, x, y, :right), do: [{x - 1, y, :up}]
  defp move(?\\, x, y, :down), do: [{x, y + 1, :left}]
  defp move(?\\, x, y, :up), do: [{x, y - 1, :right}]

  defp move(?/, x, y, :left), do: [{x - 1, y, :up}]
  defp move(?/, x, y, :right), do: [{x + 1, y, :down}]
  defp move(?/, x, y, :down), do: [{x, y - 1, :right}]
  defp move(?/, x, y, :up), do: [{x, y + 1, :left}]

  def print_path(tensor, seen) do
    seen = MapSet.new(seen, fn {x, y, _} -> {x, y} end)
    {x, y} = Nx.shape(tensor)

    for r <- 0..(x - 1), c <- 0..(y - 1) do
      color =
        cond do
          {r, c} in seen -> IO.ANSI.green()
          true -> IO.ANSI.white()
        end

      char = tensor[r][c] |> Nx.to_number()
      IO.write(color <> <<char>>)

      if c == y - 1, do: IO.write("\n")
    end

    tensor
  end
end
