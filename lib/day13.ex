defmodule Day13 do
  def get_input(), do: File.read!("./lib/inputs/day13") |> parse()
  def run_a(), do: count_mirrors(get_input(), :part_a)
  def run_b(), do: count_mirrors(get_input(), :part_b)

  defp count_mirrors(input, part) do
    for section <- input do
      row_mirrors = section |> find_mirrors(part)
      col_mirrors = section |> Nx.transpose() |> find_mirrors(part)

      Enum.sum(row_mirrors) * 100 + Enum.sum(col_mirrors)
    end
    |> Enum.sum()
  end

  defp find_mirrors(tensor, part) do
    {r, _c} = Nx.shape(tensor)
    for i <- 1..(r - 1), mirror?(tensor, i, part), do: i
  end

  defp parse(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn section ->
      section
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(fn line -> Enum.map(line, &if(&1 == "#", do: 1, else: 0)) end)
      |> Nx.tensor()
    end)
  end

  defp mirror?(tensor, i, part) do
    {r, _c} = Nx.shape(tensor)
    size = Enum.min([i, r - i])

    above = tensor[(i - size)..(i - 1)]
    below = tensor[i..(i + size - 1)] |> Nx.reverse(axes: [0])

    case part do
      :part_a -> above == below
      :part_b -> Nx.subtract(above, below) |> Nx.abs() |> Nx.sum() |> Nx.to_number() == 1
    end
  end
end
