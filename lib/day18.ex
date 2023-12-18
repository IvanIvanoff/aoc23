defmodule Day18 do
  def get_input(), do: File.read!("./lib/inputs/day18") |> Utils.split_lines() |> parse()

  def run_a() do
    get_input()
    |> get_edges()
    |> IO.inspect(label: "7", limit: :infinity)
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

  def area(edges) do
    Enum.chunk_every(edges, 2, 1, :discard)
    |> Enum.map(fn [{x1, y1}, {x2, y2}] -> x1 * y2 - x2 * y1 end)
    |> Enum.sum()
    |> abs()
    |> Kernel./(2)
  end

  defp get_edges(instructions) do
    Enum.reduce(instructions, [{0, 0}], fn {dir, steps, _color}, [curr | _] = acc ->
      [move(curr, dir, steps) | acc]
    end)
    |> Enum.reverse()
    |> print()
  end

  # defp get_path_points(instructions) do
  #   Enum.reduce(instructions, [{0, 0}], fn {dir, steps, _color}, acc ->
  #     Enum.reduce(1..steps, acc, fn _, [curr | _] = inner_acc ->
  #       [move(curr, dir, 1) | inner_acc]
  #     end)
  #   end)
  #   |> Enum.reverse()
  # end

  # defp path_area(path) do
  #   {x_l, _} = Enum.min_by(path, &elem(&1, 0))
  #   {x_r, _} = Enum.max_by(path, &elem(&1, 0))
  #   {_, y_l} = Enum.min_by(path, &elem(&1, 1))
  #   {_, y_r} = Enum.max_by(path, &elem(&1, 1))

  #   in_or_on_path =
  #     for r <- x_l..x_r, c <- y_l..y_r, {r, c} in path or inside_dig?({r, c}, path) do
  #       {r, c}
  #     end

  #   length(in_or_on_path)
  # end

  # defp inside_dig?({x, y}, path) do
  #   row_left_points = Enum.filter(path, fn {r, c} -> r == x and c < y end)

  #   inversions =
  #     Enum.count(row_left_points, fn {r, c} ->
  #       {r + 1, c} in path
  #     end)

  #   rem(inversions, 2) == 1
  # end

  defp move({x, y}, dir, step) do
    case dir do
      "D" -> {x + step, y}
      "U" -> {x - step, y}
      "L" -> {x, y - step}
      "R" -> {x, y + step}
    end
  end

  defp print(edges) do
    {x_l, _} = Enum.min_by(edges, &elem(&1, 0))
    {x_r, _} = Enum.max_by(edges, &elem(&1, 0))
    {_, y_l} = Enum.min_by(edges, &elem(&1, 1))
    {_, y_r} = Enum.max_by(edges, &elem(&1, 1))

    for x <- x_l..x_r do
      for y <- y_l..y_r do
        if {x, y} in edges do
          IO.write("X")
        else
          IO.write(".")
        end
      end

      IO.write("\n")
    end

    edges
  end
end

# U 3 (#a77fa3)
