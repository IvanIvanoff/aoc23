defmodule Day14 do
  def get_input(), do: File.read!("./lib/inputs/day14") |> Utils.split_lines() |> parse()

  # |> print()
  def run_a(), do: get_input() |> tilt_west()

  def run_b(), do: get_input()

  defp parse(lines) do
    lines
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&to_num/1)
    end)
    |> Nx.tensor()
  end

  defp tilt_west(tensor) do
    tensor = Nx.transpose(tensor)

    {height, width} = Nx.shape(tensor)
    rolling_stones = count_rolling_stones(tensor) |> IO.inspect()

    Enum.map(0..(height - 1), fn r ->
      Enum.reduce(0..(width - 1), {[], 0, 0}, fn c, {acc, s} ->
        cond do
          # non-sliding rocks are not affected
          tensor[r][c] == Nx.tensor(2) ->
            {[2 | acc], 0}

          # no sliding stones to the left
          rolling_stones[r][c] == Nx.tensor(0) ->
            {[0 | acc], s + 1}

          rolling_stones[r][c] >= Nx.tensor(s) ->
            {[1 | acc], s + 1}

          rolling_stones[r][c] < Nx.tensor(s) ->
            {[0 | acc], s + 1}
        end
      end)
      |> elem(0)
      |> Enum.reverse()
    end)
    |> Nx.tensor()
    |> Nx.transpose()
  end

  @map %{"#" => 2, "O" => 1, "." => 0}
  defp to_num(c), do: @map[c]

  def count_rolling_stones(tensor) do
    # for each position in the tensor, count the number of rolling stones
    # to the right of it, until the edge or until a
    # non-rolling stone is encountered
    h_flip_tensor = Nx.reverse(tensor, axes: [1])
    {rows, cols} = Nx.shape(h_flip_tensor)

    Enum.map(0..(rows - 1), fn r ->
      Enum.reduce(0..(cols - 1), {[], 0}, fn c, {list, prev} ->
        case h_flip_tensor[r][c] |> Nx.to_number() do
          2 -> {[0 | list], 0}
          1 -> {[prev + 1 | list], prev + 1}
          0 -> {[prev | list], prev}
        end
      end)
      |> elem(0)
    end)
    |> Nx.tensor()
  end

  @rev_map Map.new(@map, fn {k, v} -> {v, k} end)
  defp print(tensor) do
    {x, y} = Nx.shape(tensor)

    for r <- 0..(x - 1), c <- 0..(y - 1) do
      IO.write(@rev_map[Nx.to_number(tensor[r][c])])
      if c == y - 1, do: IO.write("\n")
    end

    tensor
  end
end
