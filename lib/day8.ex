defmodule Day8 do
  def get_input(), do: File.read!("./lib/inputs/day8")

  # Part A
  def run_a(input \\ get_input()) do
    input
    |> Utils.split_lines()
    |> parse()
    |> find_len()
  end

  # Part B

  def run_b(input \\ get_input()) do
    input
    |> Utils.split_lines()
    |> parse()
    |> find_ghost_len()
  end

  defp parse([instructions | rest]) do
    instructions = String.split(instructions, "", trim: true)

    rest
    |> Enum.reduce(%{"instructions" => instructions}, fn line, acc ->
      [[s], [l], [r]] = Regex.scan(~r|([0-9A-Z]+)|, line, capture: :all_but_first)
      Map.put(acc, s, %{"L" => l, "R" => r})
    end)
  end

  defp find_len(map), do: do_find_len(map["instructions"], "AAA", 0, map, &(&1 == "ZZZ"))

  defp find_ghost_len(map) do
    starting = Map.keys(map) |> Enum.filter(&String.ends_with?(&1, "A"))

    [path_length | rest] =
      Enum.map(starting, fn s ->
        do_find_len(map["instructions"], s, 0, map, &String.ends_with?(&1, "Z"))
      end)

    Enum.reduce(rest, path_length, fn a, b -> div(a * b, Integer.gcd(a, b)) end)
  end

  defp do_find_len(instructions, curr, length, map, end?) when is_function(end?, 1) do
    cond do
      end?.(curr) ->
        length

      [] == instructions ->
        do_find_len(map["instructions"], curr, length, map, end?)

      true ->
        [instruction | rest] = instructions
        next = map[curr][instruction]
        do_find_len(rest, next, length + 1, map, end?)
    end
  end
end
