defmodule Day12 do
  def get_input(), do: File.read!("./lib/inputs/day12") |> Utils.split_lines() |> parse()

  def run_a() do
    start_clean_ets()

    get_input()
    |> Enum.map(&count(&1.springs, ".", &1.groups))
    |> Enum.sum()
  end

  def run_b() do
    start_clean_ets()

    get_input()
    |> Enum.map(fn %{springs: springs, groups: groups} ->
      %{
        springs: List.duplicate(springs, 5) |> Enum.join("?"),
        groups: List.duplicate(groups, 5) |> List.flatten()
      }
    end)
    |> Enum.map(&count(&1.springs, ".", &1.groups))
    |> Enum.sum()
  end

  defp start_clean_ets() do
    if :undefined != :ets.whereis(:cache), do: :ets.delete(:cache)
    :ets.new(:cache, [:set, :public, :named_table])
  end

  defp count(springs, prev, groups) do
    case {springs, prev, groups} do
      {"", _, []} -> 1
      {"", _, [0]} -> 1
      {"", _, _} -> 0
      {"#" <> _, _, []} -> 0
      {"#" <> _, _, [0 | t]} -> 0
      {"#" <> r, _, [h | t]} -> count(r, "#", [h - 1 | t])
      {"." <> r, _, []} -> count(r, ".", [])
      {"." <> r, "#", [0 | t]} -> count(r, ".", t)
      {"." <> _, "#", [_ | _]} -> 0
      {"." <> r, ".", groups} -> count(r, ".", groups)
      {"?" <> r, "#", []} -> count(r, ".", [])
      {"?" <> r, "#", [0 | t]} -> count(r, ".", t)
      {"?" <> r, "#", [h | t]} -> count(r, "#", [h - 1 | t])
      {"?" <> r, ".", []} -> count(r, ".", [])
      {"?" <> r, ".", [0 | t]} -> count(r, ".", t)
      {"?" <> r, ".", [h | t]} -> memoize(r, h, t)
    end
  end

  defp memoize(rest, h, t) do
    # If called, the current symbol is ? and both # and . are valid options,
    # so we need to check both and sum their results
    case :ets.lookup(:cache, {rest, h, t}) do
      [] ->
        result = count(rest, "#", [h - 1 | t]) + count(rest, ".", [h | t])
        :ets.insert(:cache, {{rest, h, t}, result})
        result

      [{_key, result}] ->
        result
    end
  end

  defp parse(lines) do
    Enum.map(lines, fn line ->
      [springs, groups] = String.split(line, " ")

      groups = String.split(groups, ",") |> Enum.map(&String.to_integer/1)

      %{springs: springs, groups: groups}
    end)
  end
end
