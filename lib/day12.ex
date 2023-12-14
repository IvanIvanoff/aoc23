defmodule Day12 do
  import String, only: [split: 2, split: 3, to_integer: 1]
  import Enum, only: [map: 2, into: 3, with_index: 1]
  def get_input(), do: File.read!("./lib/inputs/day12") |> Utils.split_lines() |> parse()

  def run_a() do
    get_input()
    |> Enum.map(fn map ->
      count_combinations(
        # position in the springs
        0,
        # position in the groups
        0,
        # streak of broken springs
        0,
        map.springs,
        map.groups
      )
    end)

    # |> Enum.sum()
  end

  def run_b() do
    get_input()
  end

  defp count_combinations(pos, group, _streak, springs, groups)
       when pos == map_size(springs) do
    if group < map_size(groups), do: 0, else: 1
  end

  defp count_combinations(pos, group, streak, springs, groups) do
    IO.inspect({pos, group, streak})

    cond do
      streak == groups[group] ->
        case springs[pos + 1] do
          "." -> count_combinations(pos + 1, group + 1, 0, springs, groups)
          "#" -> 0
          "?" -> count_combinations(pos + 1, group + 1, 0, springs, groups) * 2
        end

      streak < groups[group] ->
        case springs[pos + 1] do
          nil -> 0
          "." -> 0
          "#" -> count_combinations(pos + 1, group, streak + 1, springs, groups)
          "?" -> count_combinations(pos + 1, group, streak + 1, springs, groups) * 2
        end
    end
  end

  defp parse(lines) do
    Enum.map(lines, fn line ->
      [springs, groups] = split(line, " ")

      groups =
        split(groups, ",")
        |> map(&to_integer/1)
        |> with_index()
        |> into(%{}, fn {group, index} -> {index, group} end)

      # append `.` so we can have easier counting
      springs =
        (split(springs, "", trim: true) ++ ["."])
        |> with_index()
        |> into(%{}, fn {spring, index} -> {index, spring} end)

      %{springs: springs, groups: groups}
    end)
  end
end
