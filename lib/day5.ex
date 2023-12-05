defmodule Day5 do
  def get_input(), do: File.read!("./lib/inputs/day5")
  @cache :cached_locations
  defp start_clean_ets() do
    if :ets.whereis(@cache) != :undefined do
      :ets.delete(@cache)
    end

    :ets.new(@cache, [:set, :named_table, :public])
  end

  # Part A
  def run_a(input \\ get_input()) do
    start_clean_ets()

    input
    |> String.split("\n")
    |> parse_lines()
    |> find_locations()
    |> Enum.min_by(fn {_seed, location} -> location end)
    |> elem(1)
  end

  # Part B

  def run_b(input \\ get_input()) do
    start_clean_ets()

    {map, seeds} =
      input
      |> String.split("\n")
      |> parse_lines()

    ranges =
      seeds_ranges_to_values(seeds)

    ranges
    |> Task.async_stream(fn seeds_list -> find_locations({map, seeds_list}) end,
      max_concurrency: System.schedulers_online()
    )
    |> Enum.map(fn {:ok, l} -> Enum.min_by(l, fn {_seed, location} -> location end) end)
    |> List.flatten()
    |> Enum.min_by(fn {_seed, location} -> location end)
  end

  # Private

  defp seeds_ranges_to_values(seeds) do
    Enum.chunk_every(seeds, 2)
    |> Enum.map(fn [start, len] -> start..(start + len) |> Enum.to_list() end)
  end

  defp parse_lines(lines) do
    ["seeds: " <> seeds | rest] = lines

    seeds_to_be_planted =
      seeds |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)

    rest = Enum.chunk_by(rest, &(&1 == "")) |> Enum.reject(&(&1 == [""]))

    map =
      Enum.reduce(rest, %{}, fn [map_str | values], acc ->
        # the key looks like ["seed", "soil"]
        map_name = String.trim_trailing(map_str, " map:") |> String.split("-to-", trim: true)

        values =
          Enum.reduce(values, %{}, fn numbers, inner_acc ->
            [a, b, c] = String.split(numbers, " ", trim: true) |> Enum.map(&String.to_integer/1)

            Map.put(inner_acc, a..(a + c), b..(b + c))
          end)

        Map.merge(acc, %{map_name => values})
      end)

    {map, seeds_to_be_planted}
  end

  defp keys_chain(map, "seed") do
    # Build the list of keys in the order that need to be traversed
    map_keys = Map.keys(map)

    Enum.reduce(1..length(map_keys), ["seed"], fn _, [last_key | _] = acc ->
      [_, next_key] = Enum.find(map_keys, fn [current, _next] -> current == last_key end)
      [next_key | acc]
    end)
    |> Enum.reverse()
    |> Enum.chunk_every(2, 1, :discard)
  end

  defp find_locations({map, seeds}) do
    keys_chain = keys_chain(map, "seed")

    Enum.map(seeds, fn seed ->
      {seed, seed_to_location(map, keys_chain, seed)}
    end)
  end

  defp seed_to_location(map, keys_chain, seed) do
    case :ets.lookup(@cache, seed) do
      [] ->
        location =
          Enum.reduce(keys_chain, seed, fn key, current_value ->
            list = map[key]

            case Enum.find(list, fn {_dest_range, source_range} ->
                   current_value in source_range
                 end) do
              nil -> current_value
              {d1.._d2, s1.._s2} -> current_value - s1 + d1
            end
          end)

        :ets.insert(@cache, {seed, location})

        location

      [{_seed, location}] ->
        location
    end
  end
end
