defmodule Day9 do
  import Utils, only: [split_lines: 1, consecutive_diff: 1]
  import Enum, only: [map: 2, any?: 2, sum: 1]
  import String, only: [split: 3, to_integer: 1]

  def get_input(), do: File.read!("./lib/inputs/day9")

  def run_a(input \\ get_input()),
    do: input |> split_lines() |> parse() |> map(&predict_forward/1) |> sum()

  def run_b(input \\ get_input()),
    do: input |> split_lines() |> parse() |> map(&predict_backward/1) |> sum()

  defp parse(lines), do: map(lines, fn l -> split(l, " ", trim: true) |> map(&to_integer/1) end)

  defp predict_forward(line, predicted \\ 0) do
    case any?(line, &(&1 != 0)) do
      true -> predict_forward(consecutive_diff(line), predicted + List.last(line))
      false -> predicted + List.last(line)
    end
  end

  defp predict_backward(line) do
    case any?(line, &(&1 != 0)) do
      true -> List.first(line) - predict_backward(consecutive_diff(line))
      false -> 0
    end
  end
end
