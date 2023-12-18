defmodule Day17 do
  def get_input(), do: File.read!("./lib/inputs/day17") |> parse()

  def run_a() do
    tensor = get_input()
    graph = build_graph(tensor, 1, 3)
    shortest_path = get_shortest_path(graph, tensor)
  end

  def run_b() do
    get_input()
  end

  defp parse(input) do
    input
    |> Utils.split_lines_twice()
    |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)
    |> Nx.tensor()
  end

  defp get_shortest_path(graph, tensor) do
    {x, y} = Nx.shape(tensor)
    path = Graph.dijkstra(graph, {0, 0}, {x - 1, y - 1})

    Enum.chunk_every(path, 2, 1, :discard)
    |> Enum.map(fn [a, b] ->
      %Graph.Edge{weight: weight} = Graph.edge(graph, a, b)
      weight
    end)

    # |> Enum.sum()
  end

  defp build_graph(tensor, min_step, max_step) do
    {r, c} = Nx.shape(tensor)
    max_x = r - 1
    max_y = c - 1

    for x <- 0..(r - 1),
        y <- 0..(c - 1),
        step <- min_step..max_step,
        reduce: base_graph(max_x, max_y, min_step, max_step) do
      g ->
        connections = build_points(x, y, step, max_x, max_y)
        g = Graph.add_vertex(g, {x, y, step})

        Enum.reduce(connections, g, fn {cx, cy}, graph_acc ->
          graph_acc
          |> Graph.add_vertex({cx, cy, step})
          |> Graph.add_edge({x, y, step}, {cx, cy, step}, weight: Nx.to_number(tensor[cx][cy]))
        end)
    end
  end

  defp build_points(x, y, step, max_x, max_y) do
    [{x + step, y}, {x - step, y}, {x, y - step}, {x, y + step}]
    |> Enum.filter(fn {x, y} -> x in 0..max_x and y in 0..max_y end)
  end

  defp base_graph(max_x, max_y, min_step, max_step) do
    g = Graph.new() |> Graph.add_vertices([{0, 0}, {max_x, max_y}])

    for step <- min_step..max_step, reduce: g do
      g ->
        g
        |> Graph.add_vertices([{0, 0, step}, {max_x, max_y, step}])
        |> Graph.add_edge({0, 0}, {0, 0, step}, weight: 0)
        |> Graph.add_edge({max_x, max_y, step}, {max_x, max_y}, weight: 0)
    end
  end
end
