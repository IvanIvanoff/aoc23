defmodule Day7 do
  @card_to_value ~w(X 2 3 4 5 6 7 8 9 T J Q K A) |> Enum.with_index(1) |> Map.new()
  def get_input(), do: File.read!("./lib/inputs/day7")

  # Part A
  def run_a(input \\ get_input()) do
    input
    |> Utils.split_lines()
    |> eval()
  end

  # Part B

  def run_b(input \\ get_input()) do
    input
    |> Utils.split_lines()
    |> Enum.map(&String.replace(&1, "J", "X"))
    |> eval()
  end

  defp eval(list) do
    list |> parse() |> Enum.map(fn {hand, bid} -> {hand_value(hand), bid} end) |> sort_sum()
  end

  defp parse(lines) do
    Enum.map(lines, fn line ->
      [hand, bid] = String.split(line, " ", trim: true)
      {String.split(hand, "", trim: true), String.to_integer(bid)}
    end)
  end

  defp sort_sum(list) do
    list
    |> Enum.sort_by(fn {hand_value, _bid} -> hand_value end, :asc)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_hand_value, bid}, rank}, acc -> acc + bid * rank end)
  end

  defp hand_value(cards) do
    frequencies = cards |> Enum.frequencies()
    {jokers, rest} = Map.pop(frequencies, "X", 0)

    vals =
      case rest |> Map.values() |> Enum.sort(:desc) do
        [] -> [jokers]
        [top | rest] -> [top + jokers | rest]
      end

    {vals, Enum.map(cards, &@card_to_value[&1])}
  end
end
