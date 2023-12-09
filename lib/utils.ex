defmodule Utils do
  def split_lines(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reject(&(&1 == ""))
  end

  def consecutive_diff(list) do
    Enum.chunk_every(list, 2, 1, :discard) |> Enum.map(fn [x, y] -> y - x end)
  end
end
