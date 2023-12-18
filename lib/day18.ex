defmodule Day18 do
  def get_input(), do: File.read!("./lib/inputs/day18") |> Utils.split_lines() |> parse()

  def run_a() do
    get_input()
    # |> get_path_points()
    # |> path_area()
    |> get_edges()
    |> area()
  end

  def run_b() do
    get_input()
  end

  defp parse(lines) do
    lines
    |> Enum.map(fn l ->
      [[_, dir, steps, color]] = Regex.scan(~r/^([UDLR])\s(\d+)\s\(\#([a-f0-9]+)\)/, l)
      {dir, String.to_integer(steps), color}
    end)
  end

  defp area(path) do
    Enum.map(path, fn {x, y} -> )
  end

  defp get_edges(instructions) do
    Enum.reduce(instructions, [{0, 0}], fn {dir, steps, _color}, [curr | _] = acc ->
      [move(curr, dir)] | acc]

    end)
  end

  defp get_path_points(instructions) do
    Enum.reduce(instructions, [{0, 0}], fn {dir, steps, _color}, acc ->
      Enum.reduce(1..steps, acc, fn _, [curr | _] = inner_acc -> [move(curr, dir) | inner_acc] end)
    end)
    |> Enum.reverse()
  end

  defp path_area(path) do
    {x_l, _} = Enum.min_by(path, &elem(&1, 0))
    {x_r, _} = Enum.max_by(path, &elem(&1, 0))
    {_, y_l} = Enum.min_by(path, &elem(&1, 1))
    {_, y_r} = Enum.max_by(path, &elem(&1, 1))

    in_or_on_path =
      for r <- x_l..x_r, c <- y_l..y_r, {r, c} in path or inside_dig?({r, c}, path) do
        {r, c}
      end

    length(in_or_on_path)
  end

  defp inside_dig?({x, y}, path) do
    row_left_points = Enum.filter(path, fn {r, c} -> r == x and c < y end)

    inversions =
      Enum.count(row_left_points, fn {r, c} ->
        {r + 1, c} in path
      end)

    rem(inversions, 2) == 1
  end

  defp move({x, y}, dir) do
    case dir do
      "D" -> {x, y + 1}
      "U" -> {x, y - 1}
      "L" -> {x - 1, y}
      "R" -> {x + 1, y}
    end
  end
end

# U 3 (#a77fa3)
