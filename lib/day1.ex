defmodule Day1 do
  def get_input(), do: File.read!("./lib/inputs/day1")

  # Part A
  def run_a(input \\ get_input()) do
    input
    |> Utils.split_lines()
    |> Enum.map(&run_line_a/1)
    |> Enum.sum()
  end

  defp run_line_a(line) do
    Regex.scan(~r/(\d)/, line, capture: :all_but_first)
    |> List.flatten()
    |> then(fn l -> [Enum.at(l, 0), Enum.at(l, -1)] end)
    |> Enum.join()
    |> String.to_integer()
  end

  # Part B

  def run_b(input \\ get_input()) do
    input
    |> Utils.split_lines()
    |> Enum.map(&run_line_b/1)
    |> Enum.sum()
  end

  defp run_line_b(line) do
    extract_digits(line, [])
    |> then(fn l -> [Enum.at(l, 0), Enum.at(l, -1)] end)
    |> Enum.join()
    |> String.to_integer()
  end

  defp extract_digits(<<>>, digits), do: Enum.reverse(digits)

  defp extract_digits(<<digit, rest::binary>>, digits) when digit in ?0..?9 do
    extract_digits(rest, [digit - ?0 | digits])
  end

  for {bin, digit} <- ~w(one two three four five six seven eight nine zero) |> Enum.with_index(1) do
    defp extract_digits(<<unquote(bin), _::binary>> = binary, digits) do
      # Drop only the first char
      <<_, rest::binary>> = binary
      extract_digits(rest, [unquote(digit) | digits])
    end
  end

  defp extract_digits(<<_, rest::binary>>, digits), do: extract_digits(rest, digits)
end
