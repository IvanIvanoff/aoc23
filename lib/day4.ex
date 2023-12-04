defmodule Day4 do
  import Bitwise
  def get_input(), do: File.read!("./lib/inputs/day4")

  # Part A
  def run_a(input \\ get_input()) do
    input
    |> Utils.split_lines()
    |> Enum.map(&correct_count/1)
    |> Enum.map(&(1 <<< (&1 - 1)))
    |> Enum.sum()
  end

  # Part B
  def run_b(input \\ get_input()) do
    lines = input |> Utils.split_lines()

    lines
    |> count_duplicates()
    |> Kernel.+(length(lines))
  end

  # Private
  def correct_count(line) do
    ["Card " <> _card_num, winning, guesses] = String.split(line, [":", "|"])
    winning = to_integers_list(winning)
    guesses = to_integers_list(guesses)
    # -- is right assoc
    correct = guesses -- guesses -- winning
    length(correct)
  end

  defp count_duplicates(lines) do
    max_line = length(lines) - 1
    idx_correct = Enum.with_index(lines, fn line, i -> {i, correct_count(line)} end)
    lines_map = Map.new(idx_correct, fn {idx, correct} -> {idx, correct} end)

    do_count_duplicates(idx_correct, lines_map, max_line, 0)
  end

  defp do_count_duplicates([{_idx, _correct = 0} | rest], lines_map, max_line, acc) do
    do_count_duplicates(rest, lines_map, max_line, acc)
  end

  defp do_count_duplicates([{idx, correct} | rest], lines_map, max_line, acc) when correct > 0 do
    duplicates =
      for i <- (idx + 1)..(idx + correct),
          i <= max_line,
          do: {i, lines_map[i]}

    do_count_duplicates(duplicates ++ rest, lines_map, max_line, length(duplicates) + acc)
  end

  defp do_count_duplicates([], _, _, acc), do: acc

  defp to_integers_list(str),
    do: String.split(str, " ", trim: true) |> Enum.map(&String.to_integer/1)
end
