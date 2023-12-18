defmodule Day18 do
  def get_input(), do: File.read!("./lib/inputs/day18") |> Utils.split_lines() |> parse()
  def run_a(), do: get_input() |> get_vertices(:part_1) |> area()
  def run_b(), do: get_input() |> get_vertices(:part_2) |> area()

  defp parse(lines) do
    lines
    |> Enum.map(fn l ->
      [[_, dir, steps, color]] = Regex.scan(~r/^([UDLR])\s(\d+)\s\(\#([a-f0-9]+)\)/, l)
      {dir, String.to_integer(steps), color}
    end)
  end

  def area(vertices) do
    vertices
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [{x1, y1}, {x2, y2}] ->
      x1 * y2 - x2 * y1 + abs(x2 - x1) + abs(y2 - y1)
    end)
    |> Enum.sum()
    |> abs()
    |> Kernel./(2)
    |> Kernel.+(1)
  end

  defp get_vertices(instructions, :part_1) do
    [{0, 0}] ++
      Enum.reduce(instructions, [{0, 0}], fn {dir, steps, color}, [curr | _] = acc ->
        [move(curr, dir, steps) | acc]
      end)
  end

  @dir %{"0" => "R", "1" => "D", "2" => "L", "3" => "U"}
  defp get_vertices(instructions, :part_2) do
    [{0, 0}] ++
      Enum.reduce(
        instructions,
        [{0, 0}],
        fn {_dir, _steps, <<steps::binary-size(5), dir::binary-size(1)>>}, [curr | _] = acc ->
          [move(curr, @dir[dir], String.to_integer(steps, 16)) | acc]
        end
      )
  end

  defp move({x, y}, dir, step) do
    case dir do
      "D" -> {x + step, y}
      "U" -> {x - step, y}
      "L" -> {x, y - step}
      "R" -> {x, y + step}
    end
  end
end
