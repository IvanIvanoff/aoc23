defmodule Day7 do
  @card_to_value ~w(2 3 4 5 6 7 8 9 T J Q K A) |> Enum.with_index(2) |> Map.new()
  def get_input(), do: File.read!("./lib/inputs/day7")

  # Part A
  def run_a(input \\ get_input()) do
    input
    |> Utils.split_lines()
    |> parse_eval_sort()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {[_hand_value, bid], rank}, acc -> acc + bid * rank end)
  end

  # Part B

  def run_b(input \\ get_input()) do
    input
    |> Utils.split_lines()
  end

  defp parse_eval_sort(lines) do
    Enum.map(lines, fn line ->
      [cards, bid] = String.split(line, " ", trim: true)
      [hand_value(cards), String.to_integer(bid)]
    end)
    |> Enum.sort_by(fn [hand_value, _bid] -> hand_value end, :asc)
  end

  defp hand_value(hand) do
    cards = String.split(hand, "", trim: true)
    frequencies = cards |> Enum.frequencies() |> Map.values() |> Enum.sort(:desc)
    {frequencies, Enum.map(cards, &@card_to_value[&1])}
  end
end
