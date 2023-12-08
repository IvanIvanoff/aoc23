defmodule Day8 do
  def get_input(), do: File.read!("./lib/inputs/day8")

  def run_a(input \\ get_input()), do: input |> Utils.split_lines() |> parse() |> find_len()
  def run_b(input \\ get_input()), do: input |> Utils.split_lines() |> parse() |> find_ghost_len()

  defp parse([instructions | rest]) do
    instructions = String.split(instructions, "", trim: true)

    Enum.reduce(rest, %{"instructions" => instructions}, fn line, acc ->
      [[s], [l], [r]] = Regex.scan(~r|([0-9A-Z]+)|, line, capture: :all_but_first)
      Map.put(acc, s, %{"L" => l, "R" => r})
    end)
  end

  defp find_len(map), do: do_find_len(map["instructions"], "AAA", 0, map, &(&1 == "ZZZ"))

  defp find_ghost_len(map) do
    Enum.filter(Map.keys(map), &String.ends_with?(&1, "A"))
    |> Enum.map(fn start ->
      do_find_len(map["instructions"], start, 0, map, &String.ends_with?(&1, "Z"))
    end)
    |> then(fn [first_path_len | rest] ->
      Enum.reduce(rest, first_path_len, &div(&1 * &2, Integer.gcd(&1, &2)))
    end)
  end

  defp do_find_len(instructions, curr, len, map, end?) when is_function(end?, 1) do
    cond do
      end?.(curr) -> len
      [] == instructions -> do_find_len(map["instructions"], curr, len, map, end?)
      true -> do_find_len(tl(instructions), map[curr][hd(instructions)], len + 1, map, end?)
    end
  end
end
