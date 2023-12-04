defmodule Day2 do
  def get_input(), do: File.read!("./lib/inputs/day2")

  # Part A
  @limits %{red: 12, green: 13, blue: 14}

  def run_a(input \\ get_input()) do
    input
    |> Utils.split_lines()
    |> Enum.map(&line_to_map/1)
    |> Enum.reject(fn map ->
      Enum.any?(@limits, fn {color, limit} -> Map.get(map, color) > limit end)
    end)
    |> Enum.map(& &1.game_number)
    |> Enum.sum()
  end

  # Part B

  def run_b(input \\ get_input()) do
    input
    |> Utils.split_lines()
    |> Enum.map(&line_to_map/1)
    |> Enum.map(&(&1.red * &1.green * &1.blue))
    |> Enum.sum()
  end

  defp line_to_map(line) do
    [[game_str, game_number]] = Regex.scan(~r/Game (\d+)\:/, line)
    line = String.trim_leading(line, game_str)
    sets = String.split(line, ";")

    sets_data =
      Enum.map(sets, &extract_sets(&1))

    %{
      game_number: String.to_integer(game_number),
      red: Enum.max_by(sets_data, & &1["red"])["red"],
      green: Enum.max_by(sets_data, & &1["green"])["green"],
      blue: Enum.max_by(sets_data, & &1["blue"])["blue"]
    }
  end

  defp extract_sets(line) do
    Regex.scan(~r/(\d+)\s+(green|red|blue)/, line)
    |> Enum.reduce(%{"red" => 0, "green" => 0, "blue" => 0}, fn [_match, number, color], acc ->
      Map.put(acc, color, String.to_integer(number))
    end)
  end
end
