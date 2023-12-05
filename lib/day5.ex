defmodule Day5 do
  def get_input(), do: File.read!("./lib/inputs/day5")

  # Part A
  def run_a(input \\ get_input()) do
    lines = input |> String.split("\n")

    ["seeds: " <> seeds | rest] = lines
    seeds = parse_seeds_a(seeds)
    map = rest |> parse_map()

    find_min_location_with_seed(map, seeds)
  end

  # Part B

  def run_b(input \\ get_input()) do
    lines = input |> String.split("\n")

    ["seeds: " <> seeds | rest] = lines
    seeds = parse_seeds_b(seeds)
    map = rest |> parse_map()

    find_min_location_with_seed(map, seeds)
  end

  # Private

  def find_min_location_with_seed(map, seeds) do
    keys_chain = keys_chain(map, "seed") |> Enum.reverse()
    do_find_min_location_with_seed(map, seeds, keys_chain, 0)
  end

  def do_find_min_location_with_seed(map, seeds, keys_chain, location) do
    seed = location_to_seed(map, keys_chain, location)

    if Enum.any?(seeds, fn range -> seed in range end),
      do: {seed, location},
      else: do_find_min_location_with_seed(map, seeds, keys_chain, location + 1)
  end

  def seeds_ranges_to_values(seeds) do
    Enum.chunk_every(seeds, 2)
    |> Enum.map(fn [start, len] -> start..(start + len) |> Enum.to_list() end)
  end

  def parse_seeds_a(seeds) do
    seeds
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&Range.new(&1, &1))
  end

  def parse_seeds_b(seeds) do
    seeds
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [start, len] -> Range.new(start, start + len) end)
  end

  def parse_map(lines) do
    lines = Enum.chunk_by(lines, &(&1 == "")) |> Enum.reject(&(&1 == [""]))

    Enum.reduce(lines, %{}, fn [map_str | values], acc ->
      # the key looks like ["seed", "soil"]
      map_name = String.trim_trailing(map_str, " map:") |> String.split("-to-", trim: true)

      values =
        Enum.reduce(values, %{}, fn numbers, inner_acc ->
          [a, b, c] = String.split(numbers, " ", trim: true) |> Enum.map(&String.to_integer/1)

          Map.put(inner_acc, a..(a + c - 1), b..(b + c - 1))
        end)

      Map.merge(acc, %{map_name => values})
    end)
  end

  def keys_chain(map, "seed") do
    # Build the list of keys in the order that need to be traversed
    map_keys = Map.keys(map)

    Enum.reduce(1..length(map_keys), ["seed"], fn _, [last_key | _] = acc ->
      [_, next_key] = Enum.find(map_keys, fn [current, _next] -> current == last_key end)
      [next_key | acc]
    end)
    |> Enum.reverse()
    |> Enum.chunk_every(2, 1, :discard)
  end

  def location_to_seed(map, keys_chain, location) do
    Enum.reduce(keys_chain, location, fn key, current_value ->
      list = map[key]

      case Enum.find(list, fn {dest_range, _source} -> current_value in dest_range end) do
        nil -> current_value
        {d1.._d2, s1.._s2} -> current_value + s1 - d1
      end
    end)
  end
end
